module Api
  class MainMenuResource < Api::BaseResource
    immutable

    attribute :menu

    def fetchable_fields
      %i[menu]
    end

    def menu
      model.to_hash
    end

    def self.records(options = {})
      menu = model_klass.new(user: options[:context][:user])
      menu.class.send(:define_method, :id, proc { 0 })
      result = [menu]
      result.define_singleton_method(:where) { |*_args| result }
      result
    end
  end
end
