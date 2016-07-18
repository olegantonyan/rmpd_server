class PlaylistPresenter < BasePresenter
  def media_items_and_size
    uniq_media_items.to_a.size.to_s + ' / ' + h.number_to_human_size(total_size, precision: 2)
  end

  def devices
    h.collection_links(super, :to_s, :device_path)
  end

  def name
    if files_processing.exists?
      "#{h.sanitize(super.to_s)} #{h.icon('cogs')}".html_safe
    else
      super
    end
  end

  def shuffle
    h.i18n_boolean(super)
  end

  def company
    h.link_to(super.to_s, h.safe_path_to(:company_path, super))
  end
end
