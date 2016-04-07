class MediaItemPresenter < BasePresenter
  def playlists
    h.collection_links(super, :name, :playlist_path)
  end

  def size
    h.number_to_human_size(file.size, precision: 2)
  end

  def type
    model.class.human_enum_name(super)
  end

  def file_identifier
    text = if file_processing?
             "#{h.sanitize(super.to_s)} #{h.icon('cogs')}".html_safe
           else
             super.to_s
           end
    h.link_to(text, file_url).html_safe
  end

  def file_processing
    I18n.t("views.shared.#{super}", default: super.to_s)
  end
end
