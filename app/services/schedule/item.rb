class Schedule::Item < Delegator
  attr_reader :playlist_item
  alias_method :__getobj__, :playlist_item

  def initialize(playlist_item)
    fail ArgumentError, 'expected advertising playlist item' unless playlist_item.try(:advertising?)
    @playlist_item = playlist_item
  end

  def schedule_seconds
    return [] if playbacks_per_day.zero?
    (0..playbacks_per_day).map { |i| begin_time_seconds + i * period_seconds }
  end

  def schedule_times
    schedule_seconds.map { |i| Time.at(i).utc }
  end

  def begin_time_seconds
    begin_time.seconds_since_midnight
  end

  def end_time_seconds
    end_time.seconds_since_midnight
  end

  def period_seconds
    (end_time_seconds - begin_time_seconds) / (playbacks_per_day + 1)
  end

  def appropriate_at?(time_seconds)
    begin_time_seconds <= time_seconds && time_seconds <= end_time_seconds
  end
end
