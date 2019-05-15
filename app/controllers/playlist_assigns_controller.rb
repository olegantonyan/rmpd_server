class PlaylistAssignsController < ApplicationController
  def update # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    authorize(assignable)
    assignment = Playlist::Assign.new(assignable: assignable, playlist_id: params[:playlist_id])

    respond_to do |format|
      format.html do
      end
      format.json do
        if assignment.call
          render(json: assignable.serialize)
        else
          render(json: { error: assignment.errors.full_messages.to_sentence }, status: :unprocessable_entity)
        end
      end
    end
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
end
