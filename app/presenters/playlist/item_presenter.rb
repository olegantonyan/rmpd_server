class Playlist::ItemPresenter < BasePresenter
  def self.policy_class
    Playlist::Item.policy_class
  end

  def size
    h.number_to_human_size(media_item.file.size, precision: 2)
  end

  def type
    media_item.class.human_enum_name(super)
  end

  def file_identifier
    if media_item.file_processing?
      "#{h.sanitize(super.to_s)} #{h.icon('cogs')}".html_safe
    else
      super
    end
  end

  def begin_time
    super.to_formatted_s(:rmpd_custom)
  end

  def end_time
    super.to_formatted_s(:rmpd_custom)
  end

  def begin_date
    super.to_formatted_s(:rmpd_custom_date)
  end

  def end_date
    super.to_formatted_s(:rmpd_custom_date)
  end
end
