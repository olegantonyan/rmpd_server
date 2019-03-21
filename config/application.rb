require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RmpdServer
  class Application < Rails::Application
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # autoload paths
    paths = Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    config.autoload_paths += paths
    config.eager_load_paths += paths

    # DEPRECATION WARNING: Time columns will become time zone aware in Rails 5.1. This
    # still causes `String`s to be parsed as if they were in `Time.zone`,
    # and `Time`s to be converted to `Time.zone`.
    # To keep the old behavior, you must add the following to your initializer:
    #     config.active_record.time_zone_aware_types = [:datetime]
    # To silence this deprecation warning, add the following:
    #     config.active_record.time_zone_aware_types << :time
    config.active_record.time_zone_aware_types = [:datetime]

    config.assets.enabled = false
  end
end
