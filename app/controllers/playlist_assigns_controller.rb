class PlaylistAssignsController < ApplicationController
  def update
    authorize(assignable)
    assignment = Playlist::Assign.new(assignable: assignable, playlist: Playlist.find(playlist_assignment_params[:playlist_id]))
    assignment.call
  end

  private

  def assignable
    if params[:device_id]
      Device.find(params[:device_id])
    elsif params[:device_group_id]
      Device::Group.find(params[:device_group_id])
    else
      raise 'No assignable object'
    end
  end

  def playlist_assignment_params
    params.require(:playlist_assignment).permit(:playlist_id)
  end
end
