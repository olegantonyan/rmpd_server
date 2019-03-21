class InvitesController < ApplicationController
  def create
    invite = build_invite
    authorize invite
    crud_respond invite
  end

  def destroy
    invite = Invite.find(params[:id])
    authorize invite
    crud_respond invite
  end

  private

  def company
    Company.find(params[:company_id])
  end

  def build_invite
    Invite.new(invite_params).tap do |i|
      i.user = current_user
      i.company = company
    end
  end

  def invite_params
    params.require(:invite).permit(policy(:invite).permitted_attributes)
  end

  def crud_responder_default_options
    { success_url: :back, error_url: :back }
  end
end
