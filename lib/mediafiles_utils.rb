module MediafilesUtils
  module_function

  def convert_to_h264(src, dst)
    system(*['ffmpeg', '-i', src, '-vcodec', 'libx264', '-acodec', 'aac', '-strict', '-2', dst])
  end

  def duration(file)
    result = `ffmpeg -i '#{file}' 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`.strip.split(':')
    Duration.new(hours: result.first, minutes: result.second, seconds: result.third.to_f.round)
  end
end
