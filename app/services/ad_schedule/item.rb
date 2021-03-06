module AdSchedule
  class Item
    attr_reader :scheduled_item, :id, :begin_date, :end_date, :overlap, :schedule

    delegate :file_name, to: :playlist_item

    def initialize(scheduled_item)
      @scheduled_item = scheduled_item
      @id = scheduled_item.id
      @begin_date = scheduled_item.begin_date
      @end_date = scheduled_item.end_date
      @overlap = scheduled_item.overlap
      @schedule = scheduled_item.schedule
    end

    def playlist_item
      @playlist_item ||= Playlist::Item::Advertising.find(id)
    end

    def valid?
      !overlap
    end
  end
end
