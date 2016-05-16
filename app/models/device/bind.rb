class Device::Bind < ApplicationModel
  attr_accessor :company_id, :name, :time_zone, :device_group_ids, :login

  with_options presence: true do
    validates :login
    validates :company_id
  end
  validate :device_exists
  validate :device_not_bound_already

  def save
    return false if invalid?
    d = assign_to_device
    return true if d.save
    copy_errors(d)
    false
  end

  def device
    @_device ||= Device.find_by(login: login)
  end

  def to_s
    "#{login} -> #{company_id}"
  end

  private

  def assign_to_device
    d = device
    d.company_id = company_id
    assign_if(d, :time_zone, time_zone)
    assign_if(d, :name, name)
    assign_if(d, :device_group_ids, device_group_ids)
    d
  end

  def device_exists
    errors.add(:login, 'device not found') unless device
  end

  def device_not_bound_already
    return unless device
    errors.add(:login, 'already bound to a company') if device.bound_to_company?
  end
end
