class User
  class RegistrationService < BaseService
    def self.attributes
      %i[email password password_confirmation displayed_name company_title frontend_host invitation_token allow_notifications]
    end

    attributes.each { |a| attr_accessor a }
    attr_reader :user, :company, :accepted_invite

    # rubocop: disable Metrics/MethodLength
    def save
      ActiveRecord::Base.transaction do
        if invite
          create_user!(true)
          accept_invite!
        else
          create_user!(false)
          create_company!
        end
      end
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
    # rubocop: enable Metrics/MethodLength

    private

    attr_writer :user, :company, :accepted_invite

    def invite
      @_invite ||= Invite.find_by(token: invitation_token)
    end

    # rubocop: disable Metrics/AbcSize
    def create_user!(skip_confirmation = false)
      self.user = User.new(email: email, password: password, password_confirmation: password_confirmation)
      assign_if(user, :skip_confirmation, skip_confirmation)
      assign_if(user, :displayed_name, displayed_name)
      assign_if(user, :allow_notifications, allow_notifications)
      user.save!
    rescue ActiveRecord::RecordInvalid
      copy_errors(user)
      raise
    end
    # rubocop: enable Metrics/AbcSize

    def create_company!
      self.company = user.companies.create!(title: company_title.presence || "#{self}'s company")
      company.save!
    rescue ActiveRecord::RecordInvalid
      copy_errors(company)
      raise
    end

    def accept_invite!
      self.accepted_invite = Invite::Accept.create(invite: invite, user: user)
      accepted_invite.save!
    rescue ActiveRecord::RecordInvalid
      errors.add(:invitation_token, accepted_invite.errors.full_messages.to_sentence)
      raise
    end
  end
end
