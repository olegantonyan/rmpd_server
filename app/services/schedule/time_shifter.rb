class Schedule::TimeShifter
  attr_reader :intervals

  def initialize(intervals)
    self.intervals = intervals

    intervals.sort_by { |i| -i.playbacks_count }.each do |interval|
      sap "interval #{interval}"
      interval.items.each do |i|
        sap i.schedule_times
      end
    end
  end

  private

  attr_writer :intervals
end
