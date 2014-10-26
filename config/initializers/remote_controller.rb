#coding: utf-8

require 'xmpp4r'

Jabber::debug = true if Rails.env.development?

class Xmpp
  
  def self.connect
    jid = Jabber::JID::new(APP_CONFIG['broker_username'] + '@' + APP_CONFIG['broker_address'])
    jid.resource='rails'
    @@client = Jabber::Client::new(jid)
    @@client.connect
    @@client.auth(APP_CONFIG['broker_password'])
  end
  
  def self.message(to, text)
    message = Jabber::Message::new(to, text)
    message.set_type(:chat)
    @@client.send message
  end
  
  def self.presence
    @@client.send(Jabber::Presence.new.set_show(nil))
  end
  
  def self.listen
    self.connect
    
    self.presence
    
    @@client.add_message_callback do |message|
      if message.type != :error
        d = DeviceRemoteConnector.new
        d.received_message(message.from.strip.to_s, message.body.to_s)
      end
    end
    
    @@client.add_presence_callback do |presence|
      d = DeviceRemoteConnector.new
      d.received_presence(presence.from.strip.to_s, presence.type != :unavailable, presence.status.to_s)
    end
    
    @@client.add_iq_callback do |iq_received|
    if iq_received.type == :get
      if iq_received.queryns.to_s != 'http://jabber.org/protocol/disco#info'
        iq = Jabber::Iq.new(:result, @@client.jid.node)
        iq.id = iq_received.id
        iq.from = iq_received.to
        iq.to = iq_received.from
        @@client.send(iq)
      end
    end
end
    
  end
end

Xmpp.listen