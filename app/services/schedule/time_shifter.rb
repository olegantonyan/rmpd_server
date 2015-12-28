class Schedule::TimeShifter
  attr_reader :intervals

  def initialize(intervals)
    self.intervals = intervals

    intervals_sorted.each do |interval|
      sap "interval #{interval}"
      all_times = interval.items.each_with_object(Hash.new([])) { |e, hash| hash[e] = e.schedule_times }
      sap all_times
      sap all_times.values.flatten
      # overlapped_items = []
      # if near_any?()
    end
  end

  private

  def near?(first, second)
    ((first - 300)..(first + 300)).include?(second)
  end

  def intervals_sorted
    intervals.sort_by { |i| -i.playbacks_count }
  end

  attr_writer :intervals
end
