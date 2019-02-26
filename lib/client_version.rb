class ClientVersion
  attr_reader :rmpd, :version, :hardware, :raw_ua

  def initialize(ua_string) # rubocop: disable Metrics/MethodLength
    @raw_ua = ua_string
    if ua_string.is_a? String
      parts = ua_string.split(' ')
      @rmpd = parts[0]
      @version = Gem::Version.new(parts[1])
      @hardware = parts[2..-1].join(' ')
    else
      @rmpd = ''
      @version = Gem::Version.new(nil)
      @hardware = ''
    end
  end

  def to_s
    raw_ua
  end

  def platform
    (rmpd.match?(/android/) ? 'android' : 'linux').inquiry
  end

  def self_update_support?
    if platform.linux?
      Gem::Version.new(version) >= Gem::Version.new('0.4.16')
    elsif platform.android?
      Gem::Version.new(version) >= Gem::Version.new('0.0.17')
      # false
    else
      false
    end
  end
end
