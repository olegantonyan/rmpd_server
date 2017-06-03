class User
  class Registration < User
    attr_accessor :company_title, :invitation_token

    before_validation do
      if invite
        Invite::Accept.create!(invite: invite, user: self)
        skip_confirmation!
      else
        company = companies.build(title: company_title.blank? ? "#{self}'s company" : company_title)
        errors.add(:company_title, company.errors.full_messages.to_sentence) if company.invalid?
      end
    end

    def invite
      @_invite ||= Invite.find_by(token: invitation_token)
    end
  end
end
