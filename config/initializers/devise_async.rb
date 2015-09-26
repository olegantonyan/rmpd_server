Devise::Async.setup do |config|
  config.enabled = true
  config.backend = :delayed_job
  config.queue   = :email
end
