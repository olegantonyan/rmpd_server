class InviteMailer < ApplicationMailer
  include ApplicationHelper

  def invitation(invite)
    I18n.with_locale(:ru) do # FIXME: use prefered locale or pass it from the controller
      @body = t('mailers.invite.body', inviter: invite.user, app_title: app_title, company: invite.company)
      @url = new_user_registration_url(invitation_token: invite.token)
      mail(to: invite.email, subject: t('mailers.invite.subject', inviter: invite.user, app_title: app_title))
    end
  end
end
