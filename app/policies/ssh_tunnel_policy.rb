class SshTunnelPolicy < ApplicationPolicy
  def create?
    user.try(:root?)
  end

  def index?
    create?
  end
end
