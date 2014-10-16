class MediaDeployment < ActiveRecord::Base
  
  belongs_to :media_item
  belongs_to :playlist
end
