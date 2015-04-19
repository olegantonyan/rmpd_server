module InitializerHelpers
  
  # skip console, rails generators and rake
  def self.skip_console_rake &block
    raise ArgumentError.new("no block given") if block.blank?
    unless defined?(Rails::Console) or defined?(Rails::Generators) or File.basename($0) == "rake"
      yield
    end
  end
  
end