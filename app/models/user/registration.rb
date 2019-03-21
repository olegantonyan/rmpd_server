class User
  class Registration < User
    attr_accessor :company_title, :invitation_token

    before_validation do
      if invite
        accept = Invite::Accept.create(invite: invite, user: self)
        if accept.save
          skip_confirmation!
        else
          errors.add(:base, accept.errors.full_messages.to_sentence)
        end
      else
        company = companies.build(title: company_title.presence || "#{self}'s company")
        errors.add(:company_title, company.errors.full_messages.to_sentence) if company.invalid?
      end
    end

    def invite
      @invite ||= Invite.find_by(token: invitation_token)
    end
  end
end
