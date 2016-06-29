class ChunkedUpload
  def initialize(file, content_range, tmp_path)
    @input_file = file
    @content_range = content_range
    @filepath = File.join(tmp_path, sanitize_filename(@input_file.original_filename))
    FileUtils.mkdir_p(tmp_path) unless File.directory?(tmp_path)
  end

  def save
    File.open(@filepath, offset == 0 ? 'wb' : 'ab') do |f|
      f.write(@input_file.read)
    end
  end

  def done?
    return true unless @content_range
    sp = @content_range.split('/')
    total = sp.last.to_i
    read_upto = sp.first.split('-').last.to_i
    read_upto + 1 == total
  end

  def cleanup
    File.delete(@filepath)
  end

  def file
    @_file ||= ActionDispatch::Http::UploadedFile.new(tempfile: File.new(@filepath),
                                                      filename: @input_file.original_filename,
                                                      type: @input_file.content_type,
                                                      head: @input_file.headers)
  end

  private

  def sanitize_filename(name)
    name.parameterize
  end

  def offset
    @_offset ||= @content_range.split('/').first.split('-').first.gsub('bytes ', '').to_i
  end
end
