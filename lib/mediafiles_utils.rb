require 'open3'

module MediafilesUtils
  module_function

  def duration(file)
    output = `ffmpeg -i '#{file}' 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`
    result = fix_invalid_byte_sequence(output).strip.split(':')
    result.first.to_i * 3600 + result.second.to_i * 60 + result.third.to_f.round
  end

  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength, Style/SpecialGlobalVars, Lint/UselessAssignment
  def normalize_volume(file, type: 'mp3')
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
    output_file = "/tmp/#{File.basename(file)}.#{type}"
    _, e, r = Open3.capture3(*['ffmpeg', '-y', '-i', file, '-af', "volume=#{adjustment}dB", '-c:v', 'copy', output_file])
    raise "Error normalizing audio volume of #{file} (#{e})" unless r.success?
    FileUtils.rm(file)
    FileUtils.cp(output_file, file)
    FileUtils.rm(output_file)
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength, Style/SpecialGlobalVars, Lint/UselessAssignment

  def fix_invalid_byte_sequence(str)
    str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
  end
end
