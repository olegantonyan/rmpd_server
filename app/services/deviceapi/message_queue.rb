class Deviceapi::MessageQueue < ActiveRecord::Base
  self.table_name = 'deviceapi_message_queue'

  validates :key, presence: true, length: { maximum: 512 }

  def self.enqueue(key, data, message_type)
    logger.debug("Enqueue message to '#{key}': '#{data}'")
    create(key: key, data: data, message_type: message_type)
  end

  def self.dequeue(key)
    d = where(key: key, dequeued: false).order(:created_at).first
    if d
      d.update(dequeued: true)
      logger.debug("Dequeue message for '#{key}': '#{d.data}', sequence '#{d.id}'")
      [d.data, d.id]
    else
      ['', 0]
    end
  end

  def self.remove(sequence_number)
    d = find_by(id: sequence_number)
    if d
      logger.debug("Remove message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
      d.destroy
    end
  end

  def self.reenqueue(sequence_number)
    d = find_by(id: sequence_number)
    unless d.nil?
      logger.debug("Reenqueue message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
      d.dequeued = false
      d.reenqueue_retries += 1
      d.save
    end
  end

  def self.retries(sequence_number)
    find_by(id: sequence_number).try(:reenqueue_retries) || 0
  end

  def self.reenqueue_all(key)
    logger.debug("Reenqueue all dequed messages for '#{key}'")
    where(key: key, dequeued: true).update_all(['reenqueue_retries = reenqueue_retries + 1, dequeued = ?', false])
  end

  def self.destroy_all_messages(key)
    logger.debug("Destroy all messages for '#{key}'")
    destroy_all(key: key)
  end

  def self.destroy_messages_with_type(key, message_type)
    destroy_all(key: key, message_type: message_type)
  end

  def self.message_type_for_sequence_number(sequence_number)
    find_by(id: sequence_number).try(:message_type)
  end
end
