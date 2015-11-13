class Playlist::Assignment
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :playlist_id, :assignable

  validates_presence_of :assignable

  def save
    sap playlist_id
    sap assignable
    return false unless valid?
    assignable.playlist = playlist_id.present? ? Playlist.find(playlist_id) : nil
    assignable.save
  end

end
