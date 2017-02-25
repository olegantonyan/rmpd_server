class Api::PlaylistItemResource < Api::BaseResource
  model_name 'Playlist::Item'

  attributes :position, :begin_time, :end_time, :playbacks_per_day, :begin_date, :end_date, :schedule, :wait_for_the_end, :show_duration

  has_one :media_item
  has_one :playlist
end
