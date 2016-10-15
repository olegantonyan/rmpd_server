class Deviceapi::MessageQueue < ActiveRecord::Base
  self.table_name = 'deviceapi_message_queue'

  validates :key, presence: true, length: { maximum: 512 }

  def self.enqueue(key, data, message_type)
    Rails.logger&.debug("Enqueue message to '#{key}': '#{data}'")
    create(key: key, data: data, message_type: message_type)
  end

  def self.dequeue(key)
    d = where(key: key, dequeued: false).order(:created_at).first
    if d
      d.update(dequeued: true)
      Rails.logger&.debug("Dequeue message for '#{key}': '#{d.data}', sequence '#{d.id}'")
      [d.data, d.id]
    else
      ['', 0]
    end
  end

  def self.remove(sequence_number)
    d = find_by(id: sequence_number)
    return unless d
    Rails.logger&.debug("Remove message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
    d.destroy
  end

  def self.reenqueue(sequence_number)
    d = find_by(id: sequence_number)
    return unless d
    Rails.logger&.debug("Reenqueue message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
    d.dequeued = false
    d.reenqueue_retries += 1
    d.save
  end

  def self.retries(sequence_number)
    find_by(id: sequence_number).try(:reenqueue_retries) || 0
  end

  def self.reenqueue_all(key, only_types = nil)
    Rails.logger&.debug("Reenqueue all dequed messages for '#{key}'")
    if only_types
      where(key: key, dequeued: true, message_type: only_types)
    else
      where(key: key, dequeued: true)
    end.update_all(['reenqueue_retries = reenqueue_retries + 1, dequeued = ?', false])
  end

  def self.destroy_all_messages(key)
    Rails.logger&.debug("Destroy all messages for '#{key}'")
    where(key: key).destroy_all
  end

  def self.destroy_messages_with_type(key, message_type)
    where(key: key, message_type: message_type).destroy_all
  end

  def self.message_type_for_sequence_number(sequence_number)
    find_by(id: sequence_number).try(:message_type)
  end
end
