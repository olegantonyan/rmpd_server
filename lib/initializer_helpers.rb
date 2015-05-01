module InitializerHelpers
  
  # skip console, rails generators and rake
  def self.skip_console_rake_generators &block
    self.skip(defined?(Rails::Console) || defined?(Rails::Generators) || File.basename($0) == "rake", &block) 
  end
  
  def self.skip_rake_generators &block
    self.skip(defined?(Rails::Generators) || File.basename($0) == "rake", &block) 
  end
  
  private
  
    def self.skip(condition, &block)
      raise ArgumentError.new("no block given") if block.blank?
      unless condition
        yield
      end 
    end
  
end