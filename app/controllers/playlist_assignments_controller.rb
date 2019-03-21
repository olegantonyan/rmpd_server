class PlaylistAssignmentsController < ApplicationController
  before_action :set_assignable

  def update
    assignment = Playlist::Assignment.new(assignable: @assignable, playlist_id: playlist_assignment_params[:playlist_id])
    authorize assignment
    crud_respond assignment, success_url: :back, error_url: :back
  end

  private

  def set_assignable
    @assignable = if params[:device_id]
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
