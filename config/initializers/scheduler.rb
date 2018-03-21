unless defined?(Rails::Console)
  require 'rufus-scheduler'

  scheduler = Rufus::Scheduler.singleton

  scheduler.every '10s' do
    Deviceapi::Timeouts.check
  end

  scheduler.cron '5 0 * * *' do
    TmpUploadsCleanupJob.perform_later
  end
end
