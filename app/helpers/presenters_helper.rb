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

        def self.policy_class
          @_policy_class
        end

        def self.human_attribute_name(*args)
          @_original_collection.human_attribute_name(*args)
        end if @_original_collection.respond_to?(:human_attribute_name)

        def self.model_name(*args)
          @_original_collection.model_name(*args)
        end if @_original_collection.respond_to?(:model_name)

        def self.total_pages
          @_original_collection.total_pages
        end if @_original_collection.respond_to?(:total_pages)

        def self.current_page
          @_original_collection.current_page
        end if @_original_collection.respond_to?(:current_page)
      end
    end
  end
  # rubocop: enable Lint/NestedMethodDefinition, Metrics/MethodLength
end
