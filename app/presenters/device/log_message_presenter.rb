class Device
  class LogMessagePresenter < BasePresenter
    def localtime
      tz = model.device.time_zone
      if tz.present?
        super.in_time_zone(tz)
      else
        super
      end
    end
  end
end
