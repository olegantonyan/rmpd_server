class MediaItemPresenter < BasePresenter
  def playlists
    h.collection_links(super, :name, :playlist_path)
  end

  def size
    h.number_to_human_size(super, precision: 2)
  end

  def type
    model.class.human_enum_name(super)
  end

  def tags
    super.pluck(:name).join(', ')
  end

  # rubocop: disable Metrics/AbcSize
  def file_identifier
    filename = truncate_filename(super.to_s)
    text = if file_processing_failed?
             "#{h.icon('exclamation-triangle')} #{h.sanitize(filename)}".html_safe
           elsif file_processing?
             "#{h.icon('cogs')} #{h.sanitize(filename)}".html_safe
           else
             filename
           end
    h.link_to(text, file_url).html_safe
  end
  # rubocop: enable Metrics/AbcSize

  def file_processing
    h.i18n_boolean(super)
  end

  def volume_normalized
    h.i18n_boolean(super)
  end

  def library_shared
    h.i18n_boolean(super)
  end

  def company
    h.link_to(super.to_s, h.safe_path_to(:company_path, super))
  end

  def duration
    (Time.mktime(0) + super).strftime('%H:%M:%S')
  end

  private

  def truncate_filename(text)
    h.truncate(text, length: 50, omission: "...#{File.extname(text)}")
  end
end
