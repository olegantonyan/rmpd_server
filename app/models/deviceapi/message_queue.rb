class Deviceapi::MessageQueue < ActiveRecord::Base
  
  def self.enqueue(key, data)
    d = Deviceapi::MessageQueue.new(:key => key, :data => data, :dequeued => false)
    d.save
  end

  def self.dequeue(key)
    d = Deviceapi::MessageQueue.where(:key => key, :dequeued => false).order(:created_at).first
    unless d.nil?
      d.dequeued = true
      d.save
      [d.data, d.id]
    else
      ["", 0]
    end
  end
  
  def self.remove(sequence_number)
    return if sequence_number.nil? 
    d = Deviceapi::MessageQueue.find_by(:id => sequence_number)
    unless d.nil?
      d.destroy
    end
  end
  
  def self.reenqueue(sequence_number)
    return if sequence_number.nil?
    d = Deviceapi::MessageQueue.find_by(:id => sequence_number)
    unless d.nil?
      d.dequeued = false
      d.save
    end
  end
  
  def self.destroy_all_messages(key)
    destroy_all(:key => key)
  end
  
end