class Device::ServiceUploadPolicy < ApplicationPolicy
  def create?
    true # any autenticated device can do this
  end

  def manual_request?
    user&.root? || user.devices.include?(record&.device)
  end
end
