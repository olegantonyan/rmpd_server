#coding: utf-8

require 'xmpp4r'
require 'xmpp4r/client'
require 'xmpp4r/roster'
require 'timers'

#Jabber::debug = true if Rails.env.development?

# Low-level connector class for XMPP
class XmppConnector
  include Singleton
  
  def initialize
    @jid = Jabber::JID::new(APP_CONFIG['broker_username'] + '@' + APP_CONFIG['broker_address'])
    @jid.resource='rails'
    @client = Jabber::Client::new(@jid)
    connect
    init_presence_callback
    init_message_callback
    init_iq_callback
    init_reconnection_timer
    init_subscription_requests
    #init_update_callback
    presence
    @protocol_interface = RemoteInterface.new
  end
  
  # Connect a server using credentials from config.yml
  def connect
    @client.connect
    @client.auth(APP_CONFIG['broker_password'])
  end
  
  # Send a message to the device
  def message(to, text)
    message = Jabber::Message::new(to, text)
    message.set_type(:chat)
    @client.send message
  end
  
  # Send a presense to all devices
  def presence
    @client.send(Jabber::Presence.new.set_show(nil))
  end
  
  # Initialize callback on message received
  def init_message_callback
    @client.add_message_callback do |message|
      if message.type != :error
        @protocol_interface.received_message(message.from.strip.to_s, message.body.to_s)
      end
    end
  end
  
  # Initialize callback on presense received
  def init_presence_callback
    @client.add_presence_callback do |presence|
      unless presence.from == @jid
        @protocol_interface.received_presence(presence.from.strip.to_s, presence.type != :unavailable, presence.status.to_s)
      end
    end
  end
  
  # Initialize callback on ping iq received
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
  
  # Initialize a reconnection mechanism
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
  
  # Initialize a callback for adding new devices to the roster
  def init_subscription_requests
    @roster = Jabber::Roster::Helper.new(@client)
    @roster.add_subscription_request_callback do |item, pres|
      puts "subscription request from " + pres.from.to_s
      if pres.from.domain == @jid.domain
        @roster.accept_subscription(pres.from)
        @roster.add(pres.from, pres.from, true)
      end
    end
  end
  
  def init_update_callback
    @roster.add_update_callback do |presence|
      if presence.from.domain == @jid.domain && presence.ask == :subscribe
        @client.send(presence.from, "added")
      end
    end
  end
  
  # Returns true if connected to the XMPP server
  def online?
    return @client.is_connected?
  end

end

if defined?(Rails::Console) || defined?(Rails::Generators) || File.basename($0) == "rake"
  class FakeXmpp
    def message(a, b)
      puts "FakeXmpp message to #{a}:#{b}"
    end
  end
  Xmpp = FakeXmpp.new
else
  Xmpp = XmppConnector.instance
end