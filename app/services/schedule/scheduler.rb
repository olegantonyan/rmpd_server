class Schedule::Scheduler
  attr_reader :items

  def initialize(itms)
    self.items = itms.select(&:advertising?).map { |i| Schedule::Item.new(i) }
    1.upto(items.size * 2) do
      optimize
      break unless overlap
    end
  end

  def items_with_times
    items.each_with_object([]) { |e, a| e.schedule_seconds.each { |ss| a << [ss, e] } }.sort_by(&:first)
  end

  def overlap
    items_with_times.each_cons(2) do |i|
      crnt, nxt = *i
      return crnt.second, nxt.second if near?(crnt, nxt)
    end
    nil
  end

  private

  attr_writer :items

  def optimize
    items_with_times.each_cons(2) do |i|
      crnt, nxt = *i
      next unless near?(crnt, nxt)
      shift_time(crnt.second, nxt.second)
      break
    end
  end

  def near?(one, two)
    delta = base_time_shift
    ((one.first - delta)..(one.first + delta)).cover?(two.first)
  end

  def shift_time(one, two)
    if two.max_positive_allowed_shift >= base_time_shift
      two.time_shift += base_time_shift
    elsif one.max_negative_allowed_shift >= base_time_shift
      one.time_shift -= base_time_shift
    end
  end

  def base_time_shift
    @_base_time_shift ||= items.map { |i| i.duration&.total || 180 }.max
  end
end
