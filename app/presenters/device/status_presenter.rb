class Device::StatusPresenter < BasePresenter
  def online
    I18n.t("views.shared.#{super}", default: super.to_s)
  end
end
