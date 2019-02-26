class TimeoutsCheckJob < ApplicationJob
  def perform
    Deviceapi::Timeouts.check
  end
end
