class Upload
  attr_reader :data, :content_range, :filepath, :uuid

  def initialize(data, content_range, uuid)
    raise ArgumentError, 'no uuid given' unless uuid
    self.data = data.freeze
    self.content_range = content_range.freeze
    self.uuid = uuid
    self.filepath = File.join(tmp_path, uuid).freeze
    FileUtils.mkdir_p(tmp_path) unless File.directory?(tmp_path)
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

  def file(original_filename, content_type)
    @_file ||= ActionDispatch::Http::UploadedFile.new(tempfile: File.new(filepath),
                                                      filename: original_filename,
                                                      type: content_type)
  end

  private

  attr_writer :data, :content_range, :filepath, :uuid

  def tmp_path
    File.join(Rails.root, 'public', 'uploads', 'tmp', 'uploads').freeze
  end

  def sanitize_filename(name)
    name.parameterize
  end

  def offset
    return 0 unless content_range
    @_offset ||= content_range.split('/').first.split('-').first.gsub('bytes ', '').to_i
  end
end
