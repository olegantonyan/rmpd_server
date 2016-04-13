def setup_email config
  email_settings_env = config[:email]
  ActionMailer::Base.smtp_settings = email_settings_env
  ActionMailer::Base.default from: email_settings_env[:sender]
  ActionMailer::Base.default_url_options = { host: email_settings_env[:host_for_url],
                                             port: email_settings_env[:port_for_url],
                                             protocol: email_settings_env[:protocol_for_url] }
end

config_file_path = "#{Rails.root}/config/config.yml"
if File.exists?(config_file_path)
  APP_CONFIG = YAML.load_file(config_file_path)[Rails.env].deep_symbolize_keys
  setup_email(APP_CONFIG)
else
  warn "##### Config file '#{config_file_path}' does not exists"
end
