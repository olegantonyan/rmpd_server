FactoryBot.define do
  factory :playlist_item, class: 'Playlist::Item' do
    media_item
    playlist
  end
end
