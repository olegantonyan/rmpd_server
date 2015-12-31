class Schedule::TimeShifter
  attr_reader :intervals

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def initialize(intervals)
    all_items = []
    intervals.each do |i|
      i.items.each do |j|
        all_items << j unless j.in?(all_items)
      end
    end
    all_items.each do |i|
      sap i.to_s
      sap i.schedule_times
    end
    self.intervals = intervals
    self.invariant_items = []
    self.invariant_intervals = []
    loop do
      break unless shift
    end
    sap 'finished'
    all_items = []
    intervals.each do |i|
      i.items.each do |j|
        all_items << j unless j.in?(all_items)
      end
    end
    all_items.each do |i|
      sap i.to_s
      sap i.schedule_times
    end
  end

  private

  attr_writer :intervals
  attr_accessor :invariant_items, :invariant_intervals

  def shift
    intervals_sorted.each do |interval|
      next if interval.in?(invariant_intervals)
      times_seconds = interval.items.map(&:schedule_seconds).flatten.sort
      times_seconds.each_pair_overlapped do |crnt, nxt|
        itm = item_by_time(interval, crnt)
        next if !near?(crnt, nxt) || itm.in?(invariant_items)
        itm.time_shift += 600
        invariant_items << itm
        invariant_intervals << interval
        return itm
      end
    end
    nil
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
