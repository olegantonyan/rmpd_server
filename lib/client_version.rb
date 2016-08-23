class ClientVersion
  attr_accessor :rmpd, :version, :hardware, :raw_ua

  # rubocop: disable Metrics/MethodLength
  def initialize(ua_string)
    self.raw_ua = ua_string
    if ua_string.is_a? String
      parts = ua_string.split(' ')
      self.rmpd = parts[0]
      self.version = Gem::Version.new(parts[1])
      self.hardware = parts[2..-1].join(' ')
    else
      self.rmpd = ''
      self.version = Gem::Version.new(nil)
      self.hardware = ''
    end
  end
  # rubocop: enable Metrics/MethodLength

  def to_s
    raw_ua
  end

  def platform
    (rmpd =~ /android/ ? 'android' : 'linux').inquiry
  end

  def self_update_support?
    return false unless platform.linux?
    Gem::Version.new(version) >= Gem::Version.new('0.4.16')
  end
end
