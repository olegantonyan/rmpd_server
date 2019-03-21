class QueryObject
  attr_reader :available_scopes

  def initialize(*available_scopes)
    @available_scopes = available_scopes
  end

  def call(scope, params)
    available_scopes.each do |i|
      scope = scope.public_send(i, params[i]) if params[i]
    end
    scope
  end
end
