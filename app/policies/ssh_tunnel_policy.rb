class SshTunnelPolicy < ApplicationPolicy
  def create?
    user.root?
  end

  def index?
    create?
  end
end
