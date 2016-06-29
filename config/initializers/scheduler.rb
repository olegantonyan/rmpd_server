InitializerHelpers.skip_console_rake_generators do
  require 'rufus-scheduler'

  scheduler = Rufus::Scheduler.new
  scheduler.every '10s' do
    Deviceapi::Timeouts.check
  end

  scheduler.cron '5 0 * * *' do
    TmpUploadsCleanupJob.perform_later
  end
end
