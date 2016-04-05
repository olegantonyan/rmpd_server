class User < ApplicationRecord
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  with_options inverse_of: :user do |a|
    a.has_many :user_company_memberships
  end
  has_many :companies, -> { group('companies.id') }, through: :user_company_memberships

  validates :displayed_name, length: { maximum: 130 }

  before_save :set_defaults

  scope :available_for_notifications, -> {
    where.not(confirmed_at: nil, allow_notifications: false)
  }

  def devices
    Device.where(company: companies)
  end

  rails_admin do
    object_label_method do
      :custom_label_method
    end
    list do
      field :displayed_name
      field :email
      field :created_at
      field :updated_at
      field :user_company_memberships
    end
    show do
      exclude_fields :versions
    end
    edit do
      exclude_fields :password, :password_confirmation, :user_company_memberships, :versions, :reset_password_token, :reset_password_sent_at,
                     :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at,
                     :updated_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
    end
  end

  def to_s
    "#{email} (#{displayed_name})"
  end

  private

  def set_defaults
    return if companies.any?
    companies << Company.demo
  end

  def custom_label_method
    displayed_name.blank? ? email : to_s
  end
end
