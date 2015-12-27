class Schedule::Scheduler
  attr_reader :items, :intervals, :time_shifter

  def initialize(items)
    self.items = items.select(&:advertising?).map { |i| Schedule::Item.new(i) }
    fill_intervals
    self.time_shifter = Schedule::TimeShifter.new(intervals)
  end

  private

  attr_writer :items, :intervals, :time_shifter

  def fill_intervals(all_times = all_times_seconds)
    self.intervals = []
    all_times.each_with_index do |e, idx|
      intervals << Schedule::Interval.new(e, all_times_seconds.at(idx + 1)) if idx + 1 < all_times_seconds.size
    end
    assign_items_to_intervals
  end

  def assign_items_to_intervals
    intervals.each do |interval|
      items.select { |item| item.appropriate_at?(interval.mean_time_seconds) }.each { |item| interval.add_item(item) }
    end
  end

  def all_times_seconds
    (items.map(&:begin_time_seconds) + items.map(&:end_time_seconds)).uniq.sort
  end
end
