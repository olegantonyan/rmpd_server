class Device
  class Bind
    include ActiveModel::Model
    include ActiveModel::Validations
    extend ActiveModel::Translation

    attr_accessor :company_id, :name, :time_zone, :login

    validates :login, presence: true
    validates :company_id, presence: true
    validate :device_exists
    validate :device_not_bound_already

    def save
      return false if invalid?
      d = assign_to_device
      if d.save
        notify
        true
      else
        d.errors.each { |k, v| errors.add(k, v) }
        false
      end
    end

    def device
      @device ||= Device.find_by(login: login)
    end

    def company
      Company.find(company_id)
    end

    def to_s
      "#{login} -> #{company_id}"
    end

    private

    def assign_to_device
      d = device
      d.company_id = company_id
      d.time_zone = time_zone if time_zone
      d.name = name if name
      d
    end

    def device_exists
      errors.add(:login, I18n.t('activemodel.attributes.device/bind.device_not_found')) unless device
    end

    def device_not_bound_already
      return unless device
      errors.add(:login, I18n.t('activemodel.attributes.device/bind.device_already_bound')) if device.bound_to_company?
    end

    def notify
      Notifiers::DeviceBindNotifierJob.perform_later(device)
    end
  end
end
