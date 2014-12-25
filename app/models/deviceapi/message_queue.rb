class Deviceapi::MessageQueue < ActiveRecord::Base
  
  def self.enqueue(key, data)
    logger.debug("Enqueue message to '#{key}': '#{data}'")
    d = Deviceapi::MessageQueue.new(:key => key, :data => data, :dequeued => false)
    d.save
  end

  def self.dequeue(key)
    d = Deviceapi::MessageQueue.where(:key => key, :dequeued => false).order(:created_at).first
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
    d = Deviceapi::MessageQueue.find_by(:id => sequence_number)
    unless d.nil?
      logger.debug("Remove message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
      d.destroy
    end
  end
  
  def self.reenqueue(sequence_number)
    return if sequence_number.nil?
    d = Deviceapi::MessageQueue.find_by(:id => sequence_number)
    unless d.nil?
      logger.debug("Reenqueue message for '#{d.key}': '#{d.data}', sequence '#{d.id}'")
      d.dequeued = false
      d.save
    end
  end
  
  def self.reenqueue_all(key)
    return if key.nil?
    logger.debug("Reenqueue all dequed messages for '#{key}'")
    Deviceapi::MessageQueue.where(:key => key, :dequeued => true).update_all(:dequeued => false)
  end
  
  def self.destroy_all_messages(key)
    logger.debug("Destroy all messages for '#{key}'")
    destroy_all(:key => key)
  end
  
end