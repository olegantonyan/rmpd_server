module DeviseUsers
  class InvitesController < ApplicationController
    skip_before_action :authenticate_user!, only: :sign_up

    def sign_up # rubocop: disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
      if user_signed_in?
        @user = current_user
        if invite.blank?
          redirect_to(root_path, alert: t('views.companies.invites.not_found'))
        elsif @user.email == invite.email
          render(template: 'devise/invites/accept')
        elsif invite.user_exists?
          sign_out(@user)
          authenticate_user!
        else
          sign_out(@user)
          redirect_to_sign_up_page
        end
      elsif invite.user_exists?
        authenticate_user!
      else
        redirect_to_sign_up_page
      end
    end

    def create
      srv = Invite::Accept.new(user: current_user, invite: invite)
      if srv.save
        flash[:success] = t('views.companies.invites.accept_successfull')
      else
        flash[:error] = srv.errors.full_messages.to_sentence
      end
      redirect_to(root_path)
    end

    private

    def redirect_to_sign_up_page
      redirect_to(new_user_registration_url(invitation_token: params[:invitation_token]))
    end

    def invite
      @invite ||= Invite.find_by(token: params[:invitation_token])
    end
  end
end
