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

export function text_truncate(text, size, ellipsis = '...') {
  if (text.length > size) {
    return text.substring(0, size) + ellipsis
  } else {
    return text
  }
}

export function time_string_to_date(str) {
  if (str === '' || str === null || str === undefined) {
    return null
  }

  let d = new Date()
  let time = str.match(/(\d+):(\d+):(\d+)/)
  d.setHours(parseInt(time[1]))
  d.setMinutes(parseInt(time[2]))
  d.setSeconds(parseInt(time[3]))
  return d
}

export function date_to_time_string(date) {
  if (date === null || date === undefined) {
    return null
  }

  return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}:${date.getSeconds().toString().padStart(2, '0')}`
}
