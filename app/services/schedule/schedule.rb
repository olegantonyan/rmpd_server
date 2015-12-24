class Schedule::Schedule
  attr_reader :items

  def initialize(items)
    @items = items.select(&:advertising?).map { |i| Schedule::Item.new(i) }
  end
end
