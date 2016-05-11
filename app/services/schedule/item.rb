class Schedule::Item
  attr_reader :scheduled_item, :id, :begin_date, :end_date, :overlap

  delegate :file_identifier, to: :playlist_item

  def initialize(scheduled_item)
    @scheduled_item = scheduled_item
    @id = scheduled_item.id
    @begin_date = scheduled_item.begin_date
    @end_date = scheduled_item.end_date
    @overlap = scheduled_item.overlap
    @schedule = scheduled_item.schedule
  end

  def playlist_item
    @_playlist_item ||= Playlist::Item::Advertising.find(id)
  end

  def schedule
    @schedule.map { |i| Time.zone.parse(i).utc }
  end
end
