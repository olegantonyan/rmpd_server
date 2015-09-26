class Role < ActiveRecord::Base
  # has_paper_trail # causes problems https://github.com/RolifyCommunity/rolify/issues/334
  scopify
  has_and_belongs_to_many :user_company_memberships, :join_table => :user_company_memberships_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type, :inclusion => { :in => Rolify.resource_types }, :allow_nil => true
  validates :name, presence: true, uniqueness: true, length: {:in => 2..30}

  Role.find_or_create_by!(name: 'root')
  Role.find_or_create_by!(name: 'guest')

  rails_admin do
    list do
      field :name
      field :created_at
      field :updated_at
      field :user_company_memberships
    end
    show do
      exclude_fields :versions
    end
    edit do
      exclude_fields :versions
    end
  end

  def to_s
    "#{name}"
  end

end
