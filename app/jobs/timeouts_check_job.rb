class TimeoutsCheckJob < ApplicationJob
  def perform
    Deviceapi::Timeouts.new.call
  end
end
