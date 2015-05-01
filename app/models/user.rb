class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  
  has_paper_trail
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  has_many :user_company_memberships
  has_many :companies, through: :user_company_memberships
  
  def has_role? role
    user_company_memberships.find{|c| c.has_role? role } ? true : false
  end
  
  rails_admin do 
    object_label_method do
      :custom_label_method
    end
    list do
      field :email
      field :created_at
      field :updated_at
      field :user_company_memberships
    end
    show do
      exclude_fields :versions
    end
    edit do
      field :email
      field :password
      field :password_confirmation
      field :companies
    end
  end
  
  private
  
    def custom_label_method
      email
    end
  
end
