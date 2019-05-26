class Pagination
  attr_reader :limit, :offset

  def initialize(params, default_limit: 20, max_limit: 150)
    @limit = [(params[:limit] || default_limit).to_i, max_limit].min
    @offset = params[:offset].to_i * limit
  end

  def call(scope)
    scope.limit(limit).offset(offset)
  end
end
