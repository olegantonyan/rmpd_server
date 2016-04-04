class UserCompanyMembership < ApplicationRecord
  rolify

  with_options inverse_of: :user_company_memberships do |a|
    a.belongs_to :user
    a.belongs_to :company
  end

  validates :title, length: { maximum: 130 }

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
    "#{user} in #{company}"
  end

  private

  def set_defaults
    return if roles.any?
    roles << Role.find_by('lower(name) = ?', 'guest')
  end

  def custom_label_method
    title.blank? ? to_s : title
  end
end
