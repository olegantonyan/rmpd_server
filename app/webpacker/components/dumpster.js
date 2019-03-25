export function seconds_to_string(seconds) {
  seconds = Math.round(seconds)
  let hours = Math.floor(seconds / 3600)
  seconds %= 3600
  let minutes = Math.floor(seconds / 60)
  seconds = seconds % 60

  let minutes_str = String(minutes).padStart(2, "0")
  let hours_str = String(hours).padStart(2, "0")
  let seconds_str = String(seconds).padStart(2, "0")
  if (hours > 0) {
    return hours_str + ":" + minutes_str + ":" + seconds_str
  } else {
    return minutes_str + ":" + seconds_str
  }
}

export function humanized_size(size) {
  if (size === null || size === undefined || size === 0) {
    return ''
  }
  let i = Math.floor( Math.log(size) / Math.log(1000) )
  return ( size / Math.pow(1000, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i]
}
