FactoryGirl.define do
  factory :device_service_upload, class: 'Device::ServiceUpload' do
    file { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'support', 'music_file.mp3'))) }
  end
end
