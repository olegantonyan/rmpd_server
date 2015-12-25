class Schedule::All
  attr_reader :items, :intervals

  def initialize(items)
    @items = items.select(&:advertising?).map { |i| Schedule::Item.new(i) }
    fill_intervals
    assign_items_to_intervals
    shift_items_schedule
  end

  private

  def fill_intervals(all_times = all_times_seconds_uniq_sorted)
    @intervals = []
    all_times.each_with_index do |e, idx|
      @intervals << Schedule::Interval.new(e, all_times_seconds_uniq_sorted.at(idx + 1)) if idx + 1 < all_times_seconds_uniq_sorted.size
    end
  end

  def assign_items_to_intervals
    intervals.each do |interval|
      items.each do |item|
        interval.append_item(item) if item.appropriate_at?((interval.begin_time_seconds + interval.end_time_seconds) / 2)
      end
    end
  end

  def all_times_seconds_uniq_sorted
    (items.map(&:begin_time_seconds) + items.map(&:end_time_seconds)).uniq.sort
  end

  def shift_items_schedule
    intervals.sort_by { |i| -i.playbacks_count }.each do |interval|
      sap interval.playbacks_count
    end
  end
end
