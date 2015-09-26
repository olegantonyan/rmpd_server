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

  def to_s
    "#{user.to_s} in #{company.to_s}"
  end

  private

    def set_defaults
      if self.roles.empty?
        self.roles << Role.where("lower(name) = ?", 'guest').first
      end
    end

    def custom_label_method
      title.blank? ? to_s : title
    end

end
