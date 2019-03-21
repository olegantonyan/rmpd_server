module AdSchedule
  class Scheduler
    attr_reader :items, :prepared_items

    def initialize(playlist_items)
      self.prepared_items = playlist_items.map do |i|
        raise ArgumentError, "expected advertising items only (#{i} is not)" unless i.advertising?
        RmpdAdschedule::Item.new(i.id, i.begin_date, i.end_date, i.begin_time, i.end_time, i.playbacks_per_day)
      end
      run!
    end

    def run!
      self.items = RmpdAdschedule.calculate(prepared_items).map do |i|
        AdSchedule::Item.new(i)
      end
      items
    end

    def overlap
      items.select { |i| i.overlap.any? }
    end

    private

    attr_writer :items, :prepared_items
  end
end
