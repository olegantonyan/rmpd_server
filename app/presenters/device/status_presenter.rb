class Device::StatusPresenter < BasePresenter
  def online
    h.i18n_boolean(super)
  end

  def free_space
    val = super
    return '' unless val
    h.number_to_human_size(val, precision: 2)
  end
end
