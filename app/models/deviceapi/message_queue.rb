class Deviceapi::MessageQueue < ActiveRecord::Base

  validates_presence_of :key
  validates_length_of :key, :maximum => 255

  before_save :default_values

  def self.enqueue(key, data, message_type)
    logger.debug("Enqueue message to '#{key}': '#{data}'")
    d = new(:key => key, :data => data, :dequeued => false, :message_type => message_type)
    d.save
  end

  def self.dequeue(key)
    d = where(:key => key, :dequeued => false).order(:created_at).first
    unless d.nil?
      d.dequeued = true
      d.save
      logger.debug("Dequeue message for '#{key}': '#{d.data}', sequence '#{d.id}'")
      [d.data, d.id]
    else
      ["", 0]
    end
  end

  def self.remove(sequence_number)
    return if sequence_number.nil?
    d = find_by(:id => sequence_number)
    unless d.nil?
      logger.debug("Remove message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
      d.destroy
    end
  end

  def self.reenqueue(sequence_number)
    return if sequence_number.nil?
    d = find_by(:id => sequence_number)
    unless d.nil?
      logger.debug("Reenqueue message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
      d.dequeued = false
      d.reenqueue_retries += 1
      d.save
    end
  end

  def self.retries(sequence_number)
    return 0 if sequence_number.nil?
    d = find_by(:id => sequence_number)
    unless d.nil?
      return d.reenqueue_retries
    end
    0
  end

  def self.reenqueue_all(key)
    return if key.nil?
    logger.debug("Reenqueue all dequed messages for '#{key}'")
    where(:key => key, :dequeued => true).update_all(["reenqueue_retries = reenqueue_retries + 1, dequeued = ?", false])
  end

  def self.destroy_all_messages(key)
    logger.debug("Destroy all messages for '#{key}'")
    destroy_all(:key => key)
  end

  def self.destroy_messages_with_type(key, message_type)
    destroy_all(:key => key, :message_type => message_type)
  end

  private

  def default_values
    self.reenqueue_retries ||= 0
  end

end
