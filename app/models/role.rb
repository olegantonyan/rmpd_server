class Role < ActiveRecord::Base
  has_paper_trail
  scopify
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type, :inclusion => { :in => Rolify.resource_types }, :allow_nil => true
  validates :name, presence: true, uniqueness: true, length: {:in => 2..30}
  
  rails_admin do 
    list do
      field :name
      field :created_at
      field :updated_at
      field :users
    end
    show do
      exclude_fields :versions
    end
    edit do
      exclude_fields :versions
    end
  end
  
end
