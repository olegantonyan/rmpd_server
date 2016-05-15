class InvitePresenter < BasePresenter
  def user
    h.link_to(super.to_s, h.safe_path_to(:user_path, super))
  end

  def email
    h.mail_to(super)
  end

  def accepted
    h.i18n_boolean(super)
  end
end
