module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def app_title
    return 'use load_config to initialize APP_CONFIG' unless defined? APP_CONFIG
    APP_CONFIG[:app_title] || 'set app_title in config/config.yml'
  end

  def localtime(utc_time)
    if utc_time.nil?
      ''
    else
      local_time utc_time, '%Y-%m-%d %H:%M:%S'
    end
  end

  def flash_class(level)
    case level.to_sym
    when :info
      'alert alert-info'
    when :success, :notice
      'alert alert-success'
    when :alert, :error
      'alert alert-danger'
    when :warning
      'alert alert-warning'
    end
  end

  def active_class_for(*controller)
    if controller.include?(params[:controller])
      'active'
    else
      ''
    end
  end

  def select2js_for_id(id)
    javascript_tag "$(document).ready(function() { $('##{id}').select2({ width: '100%' }); });"
  end

  def row_info(title, value, value_class = '', title_class = '')
    render partial: 'shared/row_info', locals: { title: title, value: value || '', value_class: value_class, title_class: title_class }
  end

  # rubocop: disable Lint/Eval
  def list_with_links(collection, attr_title)
    ("<ul class='list-group'>" +
    collection.map { |g| "<li class='list-group-item'>" + link_to(sanitize(eval("g.#{attr_title}")), g) + '</li>' }.join('') +
    '</ul>').html_safe
  end
  # rubocop: enable Lint/Eval

  def current_user_displayed_name
    current_user.displayed_name.blank? ? current_user.email : current_user.displayed_name
  end

  def icon_link_to(icon, text)
    raw("<i class='glyphicon glyphicon-#{icon}'></i> #{text}")
  end

  def present(model)
    return if model.blank?
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
    presenter
  end
end
