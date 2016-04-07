InitializerHelpers::skip_console_rake_generators do
  require 'rufus-scheduler'
  scheduler = Rufus::Scheduler.new
  scheduler.every '10s' do
    timeout_check
  end

  def timeout_check
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    Deviceapi::Timeouts.check
  ensure
    ActiveRecord::Base.logger = old_logger
  end
end
