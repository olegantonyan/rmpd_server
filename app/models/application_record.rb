class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  has_paper_trail

  def self.rails_admin
  end
end
