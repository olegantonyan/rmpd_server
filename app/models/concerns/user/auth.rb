module User::Auth
  extend ActiveSupport::Concern

  included do
    prepend DeviseInstanceMethods # reasoning here http://stackoverflow.com/questions/6687696/is-it-possible-to-load-devise-in-an-external-module/32905290#32905290

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  end

  class_methods do
  end

  module DeviseInstanceMethods
  end
end
