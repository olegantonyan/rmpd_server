class Device
  class LogMessage < ApplicationRecord
    belongs_to :device, inverse_of: :device_log_messages

    validates :command, presence: true
    validates :localtime, presence: true

    scope :ordered, -> { order(created_at: :desc) }
    scope :with_since_date, ->(date) { where('date(' + table_name + '.created_at) >= ?', Date.parse(date.to_s)) }
    scope :with_to_date, ->(date) { where('date(' + table_name + '.created_at) <= ?', Date.parse(date.to_s)) }

    after_commit(on: :create) { DeviceLogMessagesChannel.broadcast_to(device, serialize) }

    class << self
      def latest
        ordered.first
      end

      def write!(device, logdata, user_agent)
        message = logdata[:message] || logdata[:track]
        message = message.to_h if message.respond_to?(:to_h) && message.present?
        create!(device: device,
                localtime: Time.zone.parse(logdata[:localtime]),
                user_agent: user_agent,
                command: logdata[:command] || "#{logdata[:type]}_#{logdata[:status]}",
                message: message)
      rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
        Rails.logger&.debug("duplicate message from #{device}")
      end
    end

    def to_s
      "#{device} | #{command} | #{localtime} | #{message}"
    end

    def serialize
      d = attributes.slice('id', 'command')
      serialize_message(d)
      d['localtime'] = device.time_in_zone(localtime)
      d['created_at'] = device.time_in_zone(created_at)
      d
    end

    private

    def serialize_message(d) # rubocop: disable Metrics/MethodLength
      if %w[track_begin track_end].include?(command)
        begin
          hash_message = parse_message_to_hash
          d['media_item_type'] = hash_message['type'] if hash_message['type']
          d['message'] = hash_message['filename'].presence || message
        rescue ::StandardError
          d['message'] = message
        end
      else
        d['message'] = message
      end
    end

    def parse_message_to_hash
      JSON.parse(message.gsub(/:(\w+)/) { "\"#{$1}\"" }.gsub('=>', ':')) # rubocop: disable Style/PerlBackrefs
    end
  end
end
