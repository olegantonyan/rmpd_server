class DeviseUsers::InvitesController < BaseController
  include AuthorizationSkipable

  skip_before_action :authenticate_user!, only: :sign_up

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
  def sign_up
    if user_signed_in?
      @invite = invite
      @user = current_user
      if @invite.blank?
        redirect_to root_path, alert: t('views.invites.not_found', default: 'Could not find invite. It may be cancelled')
      elsif @user.email == @invite.email
        render template: 'devise/invites/accept'
      elsif user_exists?
        sign_out @user
        authenticate_user!
      else
        sign_out @user
        redirect_to_sign_up_page
      end
    elsif user_exists?
      authenticate_user!
    else
      redirect_to_sign_up_page
    end
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity

  def create
    srv = Invite::Accept.new(user: current_user, invite: invite)
    crud_respond srv, success_url: root_path, error_url: root_path
  end

  private

  def redirect_to_sign_up_page
    redirect_to new_user_registration_url(invitation_token: params[:invitation_token])
  end

  def invite
    Invite.find_by(token: params[:invitation_token])
  end

  def user_exists?
    User.exists?(email: invite.email)
  end
end
