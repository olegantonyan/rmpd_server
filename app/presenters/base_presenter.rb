class BasePresenter < Delegator
  attr_reader :model, :h
  alias __getobj__ model

  def initialize(model, view_context)
    @model = model
    @h = view_context
  end

  def inspect
    "#<#{self.class} model: #{model.inspect}>"
  end

  def human_attribute_name(*args)
    model.class.human_attribute_name(*args)
  end

  def model_name(*args)
    model.class.model_name(*args)
  end
end
