class Schedule::Interval
  attr_reader :begin_time_seconds, :end_time_seconds, :items

  def initialize(begin_time_seconds, end_time_seconds)
    self.begin_time_seconds = begin_time_seconds
    self.end_time_seconds = end_time_seconds
    self.items = []
  end

  def begin_time
    Time.at(begin_time_seconds).utc
  end

  def end_time
    Time.at(end_time_seconds).utc
  end

  def add_item(item)
    items << item
  end

  def playbacks_count
    items.inject(0) { |a, e| a + e.schedule_seconds.count { |s| begin_time_seconds <= s && s <= end_time_seconds } }
  end

  def mean_time_seconds
    (begin_time_seconds + end_time_seconds) / 2
  end

  def to_s
    tm_formatted = -> (tm) { tm.strftime('%H:%M:%S') }
    "#{tm_formatted[begin_time]} - #{tm_formatted[end_time]} (#{playbacks_count} playbacks, #{items.count} items)"
  end

  private

  attr_writer :begin_time_seconds, :end_time_seconds, :items
end
