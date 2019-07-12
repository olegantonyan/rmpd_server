class Device
  class ClientVersion
    attr_reader :rmpd, :version, :hardware, :raw_ua

    delegate :to_s, to: :raw_ua

    def initialize(ua_string) # rubocop: disable Metrics/MethodLength
      @raw_ua = ua_string || ''
      if ua_string.is_a?(String)
        parts = ua_string.split(' ')
        @rmpd = parts[0]
        @version = Gem::Version.new(parts[1])
        @hardware = parts[2..-1].join(' ')
      else
        @rmpd = ''
        @version = Gem::Version.new('')
        @hardware = ''
      end
    end

    def platform
      if rmpd.match?(/android/)
        'android'
      elsif rmpd.match?(/esp32/)
        'esp32'
      else
        'linux'
      end.inquiry
    end

    def self_update_support? # rubocop: disable Metrics/AbcSize
      if platform.linux?
        Gem::Version.new(version) >= Gem::Version.new('0.4.16')
      elsif platform.android?
        Gem::Version.new(version) >= Gem::Version.new('0.0.17')
      elsif platform.esp32?
        Gem::Version.new(version) >= Gem::Version.new('0.0.1')
      else
        false
      end
    end
  end
end
