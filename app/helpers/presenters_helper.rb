module PresentersHelper
  def present(model)
    return if model.blank?
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
    presenter
  end

  def present_collection(collection)
    result = collection.map { |i| present(i) }
    policy_class = policy(collection).class

    result.define_singleton_method(:policy_class) { policy_class }

    %w(human_attribute_name model_name total_pages current_page).each do |m|
      next unless collection.respond_to?(m, false)
      result.define_singleton_method(m) { |*args| collection.public_send(m, *args) }
    end
    result
  end
end
