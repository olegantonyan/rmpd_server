class InvitesController < ApplicationController
  def create # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    invite = Invite.new(invite_params)
    invite.user = current_user
    invite.company = Company.find(params[:company_id])
    authorize(invite)

    if invite.save
      InviteMailer.invitation(invite, I18n.locale).deliver_later
      flash[:success] = t('views.companies.invites.save_successfull', email: invite.email)
    else
      flash[:alert] = invite.errors.full_messages.to_sentence
    end
    redirect_to(company_path(invite.company))
  end

  def destroy
    invite = Invite.find(params[:id])
    authorize(invite)

    if invite.destroy
      flash[:success] = t('views.companies.invites.successfully_deleted')
    else
      flash[:alert] = invite.errors.full_messages.to_sentence
    end
    redirect_to(company_path(invite.company))
  end

  private

  def invite_params
    params.require(:invite).permit(policy(:invite).permitted_attributes)
  end
end
