JSONAPI.configure do |config|
  # built in paginators are :none, :offset, :paged
  config.default_paginator = :paged

  config.default_page_size = 25
  config.maximum_page_size = 500

  config.top_level_meta_include_page_count = true
  config.top_level_meta_page_count_key = :page_count

  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  config.raise_if_parameters_not_allowed = false
end

class CustomNonePaginator < JSONAPI::Paginator
  def initialize
  end

  def apply(relation, _order_options)
    relation
  end

  def calculate_page_count(record_count)
    record_count
  end
end

module PaginationHack
  def parse_pagination(page)
    if disable_pagination?
      @paginator = CustomNonePaginator.new
    else
      super
    end
  end

  def disable_pagination?
     # your logic here
     # request params are available through @params or @context variables
     # so you get your action, path or any context data
     @params[:action] == 'get_related_resources'
  end
end

JSONAPI::RequestParser.send(:prepend, PaginationHack)
