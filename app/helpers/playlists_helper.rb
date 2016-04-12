module PlaylistsHelper
  def input_for_time(ff, attribute)
    ff.input attribute, as: :string, label: false, input_html: { class: 'datetime-picker-time', value: DefaultDateTimeValue.new(ff, attribute, :rmpd_custom).call }
  end

  def input_for_date(ff, attribute)
    ff.input attribute, as: :string, label: false, input_html: { class: 'datetime-picker-date', value: DefaultDateTimeValue.new(ff, attribute, :rmpd_custom_date).call }
  end

  def input_for_media_item(ff)
    capture do
      concat ff.input(:media_item, as: :string, label: false, disabled: true)
      concat ff.input(:media_item_id, as: :hidden)
    end
  end

  def label_for_input(ff, type, attribute)
    label_tag(ff.object.public_send(type).human_attribute_name(attribute))
  end

  def advertising_title
    MediaItem.human_enum_name(:advertising)
  end

  def background_title
    MediaItem.human_enum_name(:background)
  end

  class DefaultDateTimeValue
    def initialize(ff, attribute, fmt)
      @ff = ff
      @attribute = attribute
      @fmt = fmt
    end

    def call
      @ff.object.public_send(@attribute).to_formatted_s(@fmt)
    rescue NoMethodError
      ''
    end
  end
end
