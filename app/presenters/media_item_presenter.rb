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
    h.link_to(truncate_filename(text), file_url).html_safe
  end

  def file_processing
    h.i18n_boolean(super)
  end

  def volume_normalized
    h.i18n_boolean(super)
  end

  def company
    h.link_to(super.to_s, h.safe_path_to(:company_path, super))
  end

  def duration
    super.format('%H:%M:%S')
  end

  private

  def truncate_filename(text)
    h.truncate(text, length: 50, omission: "...#{File.extname(text)}")
  end
end
