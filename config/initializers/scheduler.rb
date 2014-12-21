if defined?(Rails::Console) or defined?(Rails::Generators) or File.basename($0) == "rake"
  # skip console, rails generators and rake
else
  require 'rufus-scheduler'

  scheduler = Rufus::Scheduler.new
  
  scheduler.every '10s' do
    Deviceapi::Timeouts.check
  end
  
end
