require 'csv'

class Device
  class LogMessage < ApplicationRecord
    belongs_to :device, inverse_of: :device_log_messages

    with_options presence: true do
      validates :command
      validates :localtime
    end

    scope :ordered, -> { order(created_at: :desc) }
    scope :with_since_date, ->(date) { where('date(' + table_name + '.created_at) >= ?', Date.parse(date.to_s)) }
    scope :with_to_date, ->(date) { where('date(' + table_name + '.created_at) <= ?', Date.parse(date.to_s)) }

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

      def to_csv
        CSV.generate do |csv|
          csv << column_names
          find_each do |obj|
            csv << obj.attributes.values_at(*column_names)
          end
        end
      end
    end

    def to_s
      "#{device} | #{command} | #{localtime} | #{message}"
    end

    def to_hash
      attributes.slice('id', 'command', 'localtime', 'message', 'created_at')
    end
  end
end
