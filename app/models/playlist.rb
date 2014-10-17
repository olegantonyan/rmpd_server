class Playlist < ActiveRecord::Base
  
  has_many :media_deployments 
  has_many :media_items, :through => :media_deployments
  has_many :devices
  
end
