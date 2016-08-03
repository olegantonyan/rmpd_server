class Playlist::ItemPresenter < BasePresenter
  def self.policy_class
    Playlist::Item.policy_class
  end

  def size
    h.number_to_human_size(model.media_item.file.size, precision: 2)
  end

  def type
    model.media_item.class.human_enum_name(super)
  end

  def file_identifier
    if model.media_item.file_processing?
      "#{h.sanitize(super.to_s)} #{h.icon('cogs')}".html_safe
    else
      super
    end
  end

  def media_item
    h.link_to(super.to_s, h.safe_path_to(:media_item_path, super))
  end

  def playlist
    h.link_to(super.to_s, h.safe_path_to(:playlist_path, super))
  end

  def begin_time
    super&.to_formatted_s(:rmpd_custom)
  end

  def end_time
    super&.to_formatted_s(:rmpd_custom)
  end

  def begin_date
    super&.to_formatted_s(:rmpd_custom_date)
  end

  def end_date
    super&.to_formatted_s(:rmpd_custom_date)
  end

  def wait_for_the_end
    h.i18n_boolean(super)
  end
end
