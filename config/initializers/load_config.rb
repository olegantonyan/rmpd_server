InitializerHelpers::skip_console_rake do
  config_file_path = "#{Rails.root}/config/config.yml"
  if File.exists?(config_file_path)
    APP_CONFIG = YAML.load_file(config_file_path)[Rails.env]
  else
    STDERR.puts "Config file '#{config_file_path}' does not exists"
  end
end