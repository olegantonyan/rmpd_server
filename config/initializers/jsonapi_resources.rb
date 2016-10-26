JSONAPI.configure do |config|
  # built in paginators are :none, :offset, :paged
  config.default_paginator = :paged

  config.default_page_size = 25
  config.maximum_page_size = 100

  config.top_level_meta_include_page_count = true
  config.top_level_meta_page_count_key = :page_count

  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  config.raise_if_parameters_not_allowed = false
end
