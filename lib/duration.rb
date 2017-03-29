class Duration
  attr_accessor :hours, :minutes, :seconds

  def initialize(hours: 0, minutes: 0, seconds: 0)
    self.hours = hours.to_i
    self.minutes = minutes.to_i
    self.seconds = seconds.to_i
  end

  def total
    hours * 3600 + minutes * 60 + seconds
  end
end
