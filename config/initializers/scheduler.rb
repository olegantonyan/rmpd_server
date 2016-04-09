InitializerHelpers.skip_console_rake_generators do
  require 'rufus-scheduler'
  scheduler = Rufus::Scheduler.new
  scheduler.every '10s' do
    timeout_check
  end

  def timeout_check
    Deviceapi::Timeouts.check
  end
end
