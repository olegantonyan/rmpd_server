class DeviseBackgrounder
  def self.confirmation_instructions(record, token, opts = {})
    new(:confirmation_instructions, record, token, opts)
  end

  def self.reset_password_instructions(record, token, opts = {})
    new(:reset_password_instructions, record, token, opts)
  end

  def self.unlock_instructions(record, token, opts = {})
    new(:unlock_instructions, record, token, opts)
  end

  def self.password_change(record, opts = {})
    new(:password_change, record, nil, opts)
  end

  def initialize(method, record, token, opts = {})
    @method = method
    @record = record
    @token = token
    @opts = opts
  end

  def deliver
    # You need to hardcode the class of the Devise mailer that you
    # actually want to use. The default is Devise::Mailer.
    return if Rails.env.test?
    Devise::Mailer.delay(queue: 'mailers').send(@method, @record, @token, @opts)
  end
end
