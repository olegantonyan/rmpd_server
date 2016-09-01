CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\-\+_]/

CarrierWave.configure do |config|
  config.storage = :file
end
