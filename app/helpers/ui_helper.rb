module UiHelper
  def render_filter_form(filterrific = @filterrific)
    capture do
      form_for_filterrific filterrific, class: 'form-horizontal' do |f|
        yield f
        concat(content_tag(:div, class: 'pull-right') do
          concat render_filterrific_spinner
          concat link_to(t('views.shared.reset_filters', default: 'Reset filters'), reset_filterrific_url)
        end)
      end
    end
  end

  def filter_form_search_query(f)
    f.text_field(:search_query, class: 'filterrific-periodically-observed form-control', placeholder: t('views.shared.search', default: 'Search'), maxlength: 64)
  end

  def filter_form_select(f, attr, options = {})
    id = "select-#{attr}"
    lbl = label_by_attr(attr, options)
    capture do
      concat f.label(lbl)
      concat f.select(attr, @filterrific.select_options[attr], { include_blank: options.fetch(:include_blank, '*') }, id: id)
      concat select2js_for_id(id)
    end
  end

  def filter_form_datetime(f, attr, options = {})
    lbl = label_by_attr(attr, options)
    capture do
      concat f.label(lbl)
      concat f.text_field(attr, class: "form-control #{options.fetch(:class, '')}")
    end
  end

  def label_by_attr(attr, options = {})
    options.fetch(:label) { t("activerecord.models.#{attr.to_s.sub(/^with_/, '').sub(/w*_id/, '')}.one", default: attr.to_s) }
  end

  def select2js_for_id(id)
    javascript_tag "$(document).ready(function() { $('##{id}').select2({ width: '100%', theme: 'bootstrap' }); });"
  end

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

  def attr_value(object, attr)
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

  # rubocop: disable Metrics/AbcSize
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
  # rubocop: enable Metrics/AbcSize

  def safe_path_to(method, object)
    return '' unless object
    send(method, object)
  end
end
