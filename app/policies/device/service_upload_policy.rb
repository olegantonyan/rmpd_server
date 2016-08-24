class Device::ServiceUploadPolicy < ApplicationPolicy
  def create?
    true # any autenticated device can do this
  end

  def manual_request?
    user&.root?
  end
end
