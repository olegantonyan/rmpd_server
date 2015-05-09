class NewsMailer < ApplicationMailer
  include ApplicationHelper
  
  def notify(user)
    @user = user
    @url = root_url
    mail(to: @user.email, subject: t(:subject, :app_title => app_title, :date => Time.now.strftime('%B %d %Y')))
  end
end
