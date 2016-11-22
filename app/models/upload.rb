class Upload
  attr_reader :data, :content_range, :filepath, :uuid

  def initialize(data, content_range, uuid)
    raise ArgumentError, 'no uuid given' unless uuid
    self.data = data.freeze
    self.content_range = content_range.freeze
    self.uuid = uuid
    self.filepath = self.class.filepath_by_uuid(uuid)
    FileUtils.mkdir_p(self.class.tmp_path) unless File.directory?(self.class.tmp_path)
  end

  def save
    File.open(filepath, offset.zero? ? 'wb' : 'ab') do |f|
      f.write(data)
    end
  end

  def done?
    return true unless content_range
    sp = content_range.split('/')
    total = sp.last.to_i
    read_upto = sp.first.split('-').last.to_i
    read_upto + 1 == total
  end

  def cleanup
    File.delete(filepath)
  end

  def self.file(uuid, original_filename, content_type)
    raise ArgumentError, "uuid must be String, got #{uuid.class}" unless uuid.is_a?(String)
    ActionDispatch::Http::UploadedFile.new(tempfile: File.new(filepath_by_uuid(uuid)), filename: original_filename, type: content_type)
  rescue Errno::ENOENT
    nil
  end

  def self.tmp_path
    File.join(Rails.root, 'public', 'uploads', 'tmp', 'uploads').freeze
  end

  def self.filepath_by_uuid(uuid)
    File.join(tmp_path, uuid).freeze
  end

  private

  attr_writer :data, :content_range, :filepath, :uuid

  def sanitize_filename(name)
    name.parameterize
  end

  def offset
    return 0 unless content_range
    @_offset ||= content_range.split('/').first.split('-').first.gsub('bytes ', '').to_i
  end
end
