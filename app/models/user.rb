class User < ActiveRecord::Base
  rolify
  has_paper_trail
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  has_many :user_company_memberships
  has_many :companies, through: :user_company_memberships
  
  rails_admin do 
    object_label_method do
      :custom_label_method
    end
    list do
      field :email
      field :created_at
      field :updated_at
      field :users
    end
    show do
      exclude_fields :versions
    end
    edit do
      field :email
      field :password
      field :password_confirmation
      field :companies
      field :roles
    end
  end
  
  private
  
    def custom_label_method
      email
    end
  
end
