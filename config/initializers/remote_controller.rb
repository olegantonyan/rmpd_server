#coding: utf-8

require 'xmpp4r'
require 'timers'

Jabber::debug = true if Rails.env.development?

# Low-level connector class for XMPP
class XmppConnector
  include Singleton
  
  def initialize
    jid = Jabber::JID::new(APP_CONFIG['broker_username'] + '@' + APP_CONFIG['broker_address'])
    jid.resource='rails'
    @client = Jabber::Client::new(jid)
    init_presence_callback
    init_message_callback
    init_iq_callback
    init_reconnection_timer
  end
  
  # Connect a server using credentials from config.yml
  def connect
    @client.connect
    @client.auth(APP_CONFIG['broker_password'])
  end
  
  def message(to, text)
    message = Jabber::Message::new(to, text)
    message.set_type(:chat)
    @client.send message
  end
  
  def presence
    @client.send(Jabber::Presence.new.set_show(nil))
  end
  
  def init_message_callback
    @client.add_message_callback do |message|
      if message.type != :error
        d = DeviceRemoteConnector.new
        d.received_message(message.from.strip.to_s, message.body.to_s)
      end
    end
  end
  
  def init_presence_callback
    @client.add_presence_callback do |presence|
      d = DeviceRemoteConnector.new
      d.received_presence(presence.from.strip.to_s, presence.type != :unavailable, presence.status.to_s)
    end
  end
  
  def init_iq_callback
    @client.add_iq_callback do |iq_received|
      if iq_received.type == :get
        if iq_received.queryns.to_s != 'http://jabber.org/protocol/disco#info'
          iq = Jabber::Iq.new(:result, @client.jid.node)
          iq.id = iq_received.id
          iq.from = iq_received.to
          iq.to = iq_received.from
          @client.send(iq)
        end
      end
    end
  end
  
  def init_reconnection_timer
    timers = Timers::Group.new
    periodic_timer = timers.every(5) do
      if @client.is_disconnected?
        begin
          puts "reconnecting to #{APP_CONFIG['broker_address']} ..."
          connect
          puts "connected!"
          presence
        rescue
        end
      end
    end
    Thread.new do
      loop do
        timers.wait
      end
    end
  end
  
  def online?
    return @client.is_connected?
  end

end
  
Xmpp = XmppConnector.instance