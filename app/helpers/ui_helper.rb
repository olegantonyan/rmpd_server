# rubocop: disable Metrics/AbcSize
module UiHelper
  def attr_link_show(object, attr, link, link_class: '', link_text: nil)
    if link
      if link.is_a? String
        link_to(link_text || attr_value(object, attr), link, class: link_class)
      else
        link_to(link_text || attr_value(object, attr), link.call(object), class: link_class)
      end
    else
      attr_value(object, attr)
    end
  end

  def attr_value(object, attr) # private
    if attr.is_a?(Symbol) || attr.is_a?(String)
      object.public_send(attr)
    else
      attr.call(object)
    end
  end

  def collection_links(collection, title_attr, path_method)
    collection.map { |c| link_to(sanitize(c.public_send(title_attr)), public_send(path_method, c)) }.to_sentence.html_safe
  end

  def localized_heading(object, attribute)
    return '' unless object
    if object.is_a? ActiveRecord::Relation
      object.klass
    elsif object.is_a? ApplicationRecord
      object.class
    else
      object
    end.human_attribute_name(attribute)
  end

  def singular_title(object, attribute)
    "#{object.model_name.human} #{object.public_send(attribute)}"
  end

  def plural_title(object)
    object.model_name.human(count: object&.size || 2)
  rescue I18n::InvalidPluralizationData
    fallback_text = object&.klass&.name&.pluralize || object.class.name.pluralize
    t("activerecord.models.#{(object&.klass&.name || object.class.name).underscore}.many", default: fallback_text)
  end

  def page_title(object, singular_attr: 'to_s', template: nil)
    template = template.to_s
    if template == 'new'
      content_for(:page_title, t('views.shared.new', default: 'New') + ' ' + object.class.model_name.human)
    elsif template == 'edit'
      content_for(:page_title, t('views.shared.edit') + ' ' + singular_title(object, singular_attr))
    elsif object.is_a? Enumerable
      content_for(:page_title, plural_title(object))
    else
      content_for(:page_title, singular_title(object, singular_attr))
    end
  end

  def safe_path_to(method, object)
    return '' unless object
    send(method, object)
  end

  def i18n_boolean(arg)
    I18n.t("views.shared.#{arg}", default: arg.to_s)
  end

  def policy_presenter(object)
    if object.is_a?(BasePresenter)
      policy(object.model)
    else
      policy(object)
    end
  end

  def collapse_button(collapseable_area_id, button_text = icon_text('eye-slash', t('views.shared.show_hide', default: 'Show / Hide')))
    capture do
      concat(content_tag(:span, data: { toggle: 'button' }) do
        concat(content_tag(:span, class: 'btn btn-default btn-xs', data: { toggle: 'collapse', target: collapseable_area_id }, 'aria-expanded' => 'false') do
          button_text
        end)
      end)
    end
  end
end
