module MediafilesUtils
  module_function

  def convert_to_h264(src, dst)
    system(*['ffmpeg', '-i', src, '-vcodec', 'libx264', '-acodec', 'aac', '-strict', '-2', dst])
  end

  def duration(file)
    result = `ffmpeg -i '#{file}' 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`.strip.split(':')
    Duration.new(hours: result.first, minutes: result.second, seconds: result.third.to_f.round)
  end

  def normalize_volume(file)
    max_volume = `ffmpeg -i '#{file}' -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume`.strip&.split(':')&.last&.strip&.split(' ')&.first&.to_f
    return unless max_volume
    return if max_volume.zero?
    output_file = "/tmp/#{File.basename(file)}"
    result = system(*['ffmpeg', '-i', file, '-af', "volume=#{-max_volume}dB", '-c:v', 'copy', output_file])
    raise 'Error normalizing audio volume' unless result
    File.rename(output_file, file)
  end
end
