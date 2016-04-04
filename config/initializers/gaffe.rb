if defined?(Gaffe)
Gaffe.configure do |config|
  config.errors_controller = 'ErrorsController'
end

Gaffe.enable!
end
