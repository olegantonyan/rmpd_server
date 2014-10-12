#coding: utf-8

require "xmpp4r"

class Xmpp
  
  #параметры подключения
  @@my_xmpp_address =      "admin@localhost"     #ваш джаббер-адрес
  @@robot_xmpp_address =   "test_player0000@localhost"   #джаббер-адрес робота
  @@robot_xmpp_password =  "123456789"        #пароль от джаббер-аккаунта робота
  @@site_name =            "sitename.ru"     #имя сайта, для идентификации источника сообщений
  
  #подключение и аутентификация на xmpp-сервере
  def self.connect
    jid = Jabber::JID::new(@@robot_xmpp_address)
    jid.resource='rails'
    @@robot = Jabber::Client::new(jid)
    @@robot.connect
    @@robot.auth(@@robot_xmpp_password)
  end
  
  #отправка сообщения
  def self.message(text)
    self.connect
    message = Jabber::Message::new(@@my_xmpp_address, "[#{@@site_name}]\n#{text}")
    message.set_type(:chat)
    @@robot.send message
  end
  
  #прием сообщений
  def self.listen
    self.connect
    @@robot.send(Jabber::Presence.new.set_show(nil))
    @@robot.add_message_callback do |message| #ожидание сообщения
      if message.from.to_s.scan(@@my_xmpp_address).count > 0 #сообщение с правильного адреса
        case message.body #перебираем варианты команд для робота
        when "hello"
          Xmpp.message "И тебе привет!"
        when "restart"
          Xmpp.message "Перезагрузка..."
          File.open(Rails.root.to_s + "/tmp/restart.txt", "a+")
        end
      else #сообщение с чужого адреса
        Xmpp.message "Ко мне ломится незнакомец!"
      end
    end
  end
end

#Xmpp.listen