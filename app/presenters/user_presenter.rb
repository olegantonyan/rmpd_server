class UserPresenter < BasePresenter
  def companies
    h.collection_links(super, :to_s, :company_path)
  end

  def email
    h.mail_to(super)
  end

  def allow_notifications
    h.i18n_boolean(super)
  end
end
