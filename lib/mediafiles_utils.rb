require 'open3'

module MediafilesUtils
  module_function

  def convert_to_h264(src, dst)
    ok = system(*['ffmpeg', '-i', src, '-vcodec', 'libx264', '-vprofile', 'main', '-pix_fmt', 'yuv420p', '-acodec', 'aac', '-strict', '-2', dst])
    raise 'Error converting file to h264' unless ok
    ok
  end

  def duration(file)
    output = `ffmpeg -i '#{file}' 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`
    result = fix_invalid_byte_sequence(output).strip.split(':')
    Duration.new(hours: result.first, minutes: result.second, seconds: result.third.to_f.round)
  end

  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength, Style/SpecialGlobalVars, Lint/UselessAssignment
  def normalize_volume(file)
    output = `ffmpeg -i '#{file}' -af "volumedetect" -f null /dev/null 2>&1`
    raise "Error getting audio volume from #{file} (#{$?})" unless $?.success?
    output = fix_invalid_byte_sequence(output)
    max_volume = output.scan(/max_volume: ([\-\d\.]+) dB/).flatten.first
    mean_volume = output.scan(/mean_volume: ([\-\d\.]+) dB/).flatten.first
    return if !max_volume || !mean_volume
    max_volume = max_volume.to_f
    mean_volume = mean_volume.to_f
    target_volume = -14.0
    adjustment = target_volume - mean_volume
    output_file = "/tmp/#{File.basename(file)}"
    _, e, r = Open3.capture3(*['ffmpeg', '-y', '-i', file, '-af', "volume=#{adjustment}dB", '-c:v', 'copy', output_file])
    raise "Error normalizing audio volume of #{file} (#{e})" unless r.success?
    File.rename(output_file, file)
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength, Style/SpecialGlobalVars, Lint/UselessAssignment

  def fix_invalid_byte_sequence(str)
    str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
  end
end
