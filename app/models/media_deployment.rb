class MediaDeployment < ActiveRecord::Base
  
  belongs_to :media_item, touch: true
  belongs_to :playlist, touch: true
end
