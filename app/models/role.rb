class Role < ApplicationRecord
  find_or_create_by!(name: 'guest')

  scopify
  # rubocop: disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :user_company_memberships, join_table: :user_company_memberships_roles
  # rubocop: enable Rails/HasAndBelongsToMany
  belongs_to :resource, polymorphic: true

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, presence: true, uniqueness: true, length: { in: 2..30 }

  def self.guest
    find_by!('lower(name) = ?', 'guest')
  end

  def to_s
    name
  end
end
