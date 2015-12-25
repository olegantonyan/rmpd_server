class Schedule::Interval
  attr_reader :begin_time_seconds, :end_time_seconds
  attr_accessor :items

  def initialize(begin_time_seconds, end_time_seconds)
    @begin_time_seconds = begin_time_seconds
    @end_time_seconds = end_time_seconds
    @items = []
  end

  def begin_time
    Time.at(begin_time_seconds).utc
  end

  def end_time
    Time.at(end_time_seconds).utc
  end

  def append_item(item)
    items << item
  end

  def playbacks_count
    items.inject(0) { |a, e| a + e.schedule_seconds.count { |s| begin_time_seconds <= s && s <= end_time_seconds } }
  end
end
