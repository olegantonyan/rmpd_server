class UserCompanyMembership < ActiveRecord::Base
  has_paper_trail
  rolify
  belongs_to :user
  belongs_to :company
  
  validates :title, length: {maximum: 130}
  
  before_save :set_defaults
  
  rails_admin do 
    object_label_method do
      :custom_label_method
    end
    list do
      field :title
      field :user
      field :company
      field :roles
    end
    show do
      exclude_fields :versions
    end
    edit do
      exclude_fields :versions
    end
  end
  
  private
  
    def set_defaults
      self.role ||= Role.where("lower(name) = ?", 'guest').first
    end
    
    def custom_label_method
      title.blank? ? "#{user.email} (#{company.title})" : title
    end
  
end
