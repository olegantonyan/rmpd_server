class Upload
  class << self
    using Typerb

    def tmp_path
      Rails.root.join('public', 'uploads', 'tmp').freeze
    end

    def filepath_by_uuid(uuid)
      uuid.type!(String)
      raise ::ArgumentError, "wrong uuid format: #{uuid}" if ['/', '..'].any? { |i| uuid.include?(i) }
      File.join(tmp_path, uuid).freeze
    end
  end

  using Typerb

  attr_reader :data, :content_range, :filepath, :uuid

  def initialize(data, content_range, uuid)
    @uuid = uuid.not_nil!
    @data = data.freeze
    @content_range = content_range.freeze
    @filepath = self.class.filepath_by_uuid(uuid)
    FileUtils.mkdir_p(self.class.tmp_path) unless File.directory?(self.class.tmp_path)
  end

  def save
    File.open(filepath, offset.zero? ? 'wb' : 'ab') do |f|
      f.write(data)
    end
  end

  private

  def sanitize_filename(name)
    name.parameterize
  end

  def offset
    return 0 unless content_range
    @offset ||= content_range.split('/').first.split('-').first.gsub('bytes ', '').to_i
  end
end
