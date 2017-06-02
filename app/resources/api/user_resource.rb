class Api::UserResource < Api::BaseResource
  attributes :email, :displayed_name, :full_name, :allow_notifications, :root

  has_many :companies

  def self.updatable_fields(context)
    super - %i[root]
  end

  def self.creatable_fields(context)
    updatable_fields(context) + %i[email]
  end

  def full_name
    model.to_s
  end
end
