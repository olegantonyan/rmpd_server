class PlaylistPresenter < BasePresenter
  def media_items_and_size
    media_items.to_a.size.to_s + ' / ' + h.number_to_human_size((media_items.inject(0) { |a, e| a + e.file.size.to_i }), precision: 2)
  end

  def devices
    h.collection_links(super, :name, :device_path)
  end

  def name
    if files_processing.exists?
      "#{h.sanitize(super.to_s)} #{h.icon('cogs')}".html_safe
    else
      super
    end
  end

  def shuffle
    I18n.t("views.shared.#{super}", default: super.to_s)
  end
end
