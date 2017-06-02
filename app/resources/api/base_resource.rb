class Api::BaseResource < JSONAPI::Resource
  include Api::Concerns::AuthorizableResource

  abstract

  attributes :created_at, :updated_at

  filter :search_query, apply: ->(records, value, _options) {
    raise NotImplementedError, "no search_query scope for #{records.class} model" unless records.respond_to?(:search_query)
    records.search_query(value[0])
  }

  attr_reader :model

  def self.updatable_fields(context)
    super - %i[created_at updated_at id acl]
  end

  def self.creatable_fields(context)
    updatable_fields(context)
  end

  def self.model_klass
    _model_class
  end

  def model_klass
    self.class.model_klass
  end
end
