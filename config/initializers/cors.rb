Rails.application.config.middleware.insert_before(0, Rack::Cors) do
  allow do
    origins 'localhost:4200'
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head)
  end
  allow do
    origins 'cloud.slon-ds.ru'
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head)
  end
end
