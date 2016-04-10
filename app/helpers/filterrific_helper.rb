# rubocop: disable Metrics/MethodLength, Metrics/AbcSize
module FilterrificHelper
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
    capture do
      concat(content_tag(:div, class: 'row') do
        concat(content_tag(:div, class: 'col-sm-2') do
          concat f.label(t('views.shared.search', default: 'Search'))
        end)
        concat(content_tag(:div, class: 'col-sm-10') do
          concat f.text_field(:search_query, class: 'filterrific-periodically-observed form-control', maxlength: 64)
        end)
      end)
    end
  end

  def filter_form_select(f, attr, options = {})
    id = "select-#{attr}"
    lbl = label_by_attr(attr, options)
    capture do
      concat(content_tag(:div, class: 'row') do
        concat(content_tag(:div, class: 'col-sm-2') do
          concat f.label(lbl)
        end)
        concat(content_tag(:div, class: 'col-sm-10') do
          concat f.select(attr, @filterrific.select_options[attr], { include_blank: options.fetch(:include_blank, '*') }, id: id)
        end)
      end)
      concat select2js_for_id(id)
    end
  end

  def filter_form_datetime(f, attr, options = {})
    lbl = label_by_attr(attr, options)
    id = "datetime-picker-#{attr}"
    capture do
      concat(content_tag(:div, class: 'row') do
        concat(content_tag(:div, class: 'col-sm-2') do
          concat f.label(lbl)
        end)
        concat(content_tag(:div, class: 'col-sm-10') do
          concat f.text_field(attr, class: "filterrific-periodically-observed form-control #{options.fetch(:class, '')}", id: id)
        end)
      end)
      concat(datetime_picker_for_id(id, options.fetch(:format)))
    end
  end

  def label_by_attr(attr, options = {})
    options.fetch(:label) { t("activerecord.models.#{attr.to_s.sub(/^with_/, '').sub(/w*_id/, '')}.one", default: attr.to_s) }
  end
end
