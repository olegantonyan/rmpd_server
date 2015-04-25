def setup_email config
  email_settings_env = config[:email]
  ActionMailer::Base.smtp_settings = email_settings_env
  ActionMailer::Base.default :from => email_settings_env[:sender]
  ActionMailer::Base.default_url_options = { host: email_settings_env[:host_for_url], port: email_settings_env[:port_for_url] }
  puts email_settings_env.inspect
  puts config.inspect
end

InitializerHelpers::skip_console_rake do
  config_file_path = "#{Rails.root}/config/config.yml"
  unless File.exists?(config_file_path)
    STDERR.puts "Config file '#{config_file_path}' does not exists"
  else
    APP_CONFIG = YAML.load_file(config_file_path)[Rails.env].deep_symbolize_keys
    setup_email APP_CONFIG
  end
end

