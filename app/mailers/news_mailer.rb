class NewsMailer < ApplicationMailer
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper

  def notify(news_item)
    User.available_for_notifications.find_each do |user|
      I18n.with_locale(:ru) do # FIXME: use prefered locale or pass it from the controller
        setup_instance_vars(user, news_item)
        mail(to: user.email, subject: t(:subject, app_title: app_title, title: sanitize(news_item.title), date: news_item.created_at.strftime('%d.%m.%Y')))
      end
    end
  end

  private

  def setup_instance_vars(user, news_item)
    @url = root_url
    @news_item = news_item
    @unsibscribe_url =  edit_user_registration_url
    @signature = t(:signature, app_title: app_title)
    @greetings = "#{t(:greetings)}, #{user.displayed_name.presence || t(:dear_customer)}, #{t(:news_title)}"
  end
end
