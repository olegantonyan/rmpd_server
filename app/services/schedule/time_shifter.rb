class Schedule::TimeShifter
  attr_reader :intervals

  def initialize(intervals)
    self.intervals = intervals
    loop do
      break unless shift
    end
  end

  private

  attr_writer :intervals

  # rubocop: disable Metrics/MethodLength
  def shift
    intervals_sorted.each do |interval|
      times_seconds = interval.items.map(&:schedule_seconds).flatten.sort
      times_seconds.each_pair_overlapped do |crnt, nxt|
        next unless near?(crnt, nxt)
        itm = item_by_time(interval, crnt)
        sap itm.schedule_seconds
        itm.time_shift = 600
        sap "shifting #{itm}"
        sap itm.schedule_seconds
        return itm
      end
    end
  end

  def near?(first, second)
    ((first - 300)..(first + 300)).include?(second)
  end

  def intervals_sorted
    intervals.sort_by { |i| -i.playbacks_count }
  end

  def item_by_time(interval, tm)
    interval.items.find { |i| i.schedule_seconds.include?(tm) }
  end
end
