class Device::StatusPresenter < BasePresenter
  def online
    h.i18n_boolean(super)
  end
end
