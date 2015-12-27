class Schedule::Scheduler
  attr_reader :items, :intervals

  def initialize(items)
    self.items = items.select(&:advertising?).map { |i| Schedule::Item.new(i) }
    self.intervals = []
    fill_intervals
    shift_items_schedule
  end

  private

  attr_writer :items, :intervals

  def fill_intervals(all_times = all_times_seconds)
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

  def shift_items_schedule
    intervals.sort_by { |i| -i.playbacks_count }.each do |interval|
      sap "interval #{interval}"
      interval.items.each do |i|
        sap i.schedule_times
      end
    end
  end
end
