FactoryBot.define do
  factory :media_item do
    description { Faker::Lorem.sentence }
    file { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'support', 'music_file.mp3'))) }
    type { MediaItem.types.keys.first }
    company
    skip_file_processing { true } # bypass background processing
  end
end
