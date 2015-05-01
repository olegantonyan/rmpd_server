class TestMailer < ApplicationMailer
  #default from: 'notifications@localhost'

  def test_email(user)
    @user = user
    @url = root_url
    mail(to: @user.email, subject: 'Test email from cloud.slon-ds.ru')
  end
end