class Schedule::Scheduler
  attr_reader :items

  def initialize(itms)
    self.items = itms.select(&:advertising?).map { |i| Schedule::Item.new(i) }
    1.upto(items.map(&:schedule_times).flatten.size) do
      optimize
      break unless overlap
    end
  end

  def items_with_times(key = :schedule_seconds, value = nil)
    items.each_with_object([]) { |e, a| e.public_send(key).each { |ss| a << [ss, value ? e.public_send(value) : e] } }.sort_by(&:first)
  end

  def overlap
    items_with_times(:schedule_seconds).each_pair_overlapped do |crnt, nxt|
      return crnt.second, nxt.second if near?(crnt, nxt)
    end
    nil
  end

  private

  attr_writer :items

  def optimize
    items_with_times(:schedule_seconds).each_pair_overlapped do |crnt, nxt|
      next unless near?(crnt, nxt)
      shift_time(crnt.second, nxt.second)
      break
    end
  end

  def near?(one, two)
    delta = base_time_shift
    ((one.first - delta)..(one.first + delta)).include?(two.first)
  end

  def shift_time(one, two)
    if two.max_positive_allowed_shift >= base_time_shift
      two.time_shift += base_time_shift
    else
      if one.max_negative_allowed_shift >= base_time_shift
        one.time_shift -= base_time_shift
      end
    end
  end

  def base_time_shift
    @_base_time_shift ||= items.map { |i| i.duration.try!(:total) || 300 }.max
  end
end
