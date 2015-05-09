class NewsMailer < ApplicationMailer
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper
  
  def notify(user, news_item)
    I18n.with_locale(:ru) do # FIXME use prefered locale or pass it from the controller
      @url = root_url
      @news_item = news_item
      @unsibscribe_url =  edit_user_registration_url
      @signature = t(:signature, :app_title => app_title)
      @greetings = "#{t(:greetings)}, #{user.displayed_name.blank? ? t(:dear_customer) : user.displayed_name}, #{t(:news_title)}"
      mail(to: user.email, subject: t(:subject, :app_title => app_title, :title => sanitize(news_item.title), :date => news_item.created_at.strftime('%m.%d.%Y')))
    end
  end
  
end
