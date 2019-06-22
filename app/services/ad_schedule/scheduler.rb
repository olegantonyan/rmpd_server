module AdSchedule
  class Scheduler
    attr_reader :items, :prepared_items

    def initialize(playlist_items)
      @prepared_items = playlist_items.map do |i|
        raise ArgumentError, "expected advertising items only (#{i} is not)" unless i.advertising?
        RmpdAdschedule::Item.new(i.id, i.begin_date, i.end_date, i.begin_time, i.end_time, i.playbacks_per_day)
      end
      run!
    end

    def run!
      @items = RmpdAdschedule.calculate(prepared_items).map do |i|
        AdSchedule::Item.new(i)
      end
    end

    def valid?
      items.all?(&:valid?)
    end
  end
end
