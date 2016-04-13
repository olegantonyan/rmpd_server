FactoryGirl.define do
  factory :media_item do
    description { Faker::Lorem.sentence }
    file { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/music_file.mp3'))) }
    type { MediaItem.types.keys.first }
    company
    process_file_upload { true } # bypass background processing
  end
end
