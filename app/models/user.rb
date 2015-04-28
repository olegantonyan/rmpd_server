class User < ActiveRecord::Base
  rolify
  has_paper_trail
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  has_many :user_company_memberships
  has_many :companies, through: :user_company_memberships
  
end
