class MediaDeployment < ActiveRecord::Base
  
  belongs_to :media_item, touch: true, :autosave => true
  belongs_to :playlist, touch: true, :autosave => true
end
