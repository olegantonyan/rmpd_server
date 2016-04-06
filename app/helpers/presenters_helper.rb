module PresentersHelper
  def present(model)
    return if model.blank?
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
    presenter
  end

  # rubocop: disable Lint/NestedMethodDefinition, Metrics/MethodLength
  def present_collection(collection)
    collection.map { |i| present(i) }.tap do |result|
      result.instance_exec(collection, policy(collection).class) do |original_collection, policy_class|
        @_original_collection = original_collection
        @_policy_class = policy_class

        def self.human_attribute_name(*args)
          @_original_collection.human_attribute_name(*args)
        end

        def self.policy_class
          @_policy_class
        end

        def self.model_name(*args)
          @_original_collection.model_name(*args)
        end

        def self.total_pages
          @_original_collection.total_pages
        end

        def self.current_page
          @_original_collection.current_page
        end
      end
    end
  end
  # rubocop: enable Lint/NestedMethodDefinition, Metrics/MethodLength
end
