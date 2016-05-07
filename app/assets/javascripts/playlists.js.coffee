class MultiselectButton
  constructor: (@type) ->
    $("#mediaitems-#{@type}-add-multiple-button").click =>
      @_handle_click()

  _handle_click: =>
    items = $("#mediaitems-#{@type}-selectbox :selected").toArray()

    next_item = (i) =>
      return unless i
      @_handle_single_item(i)
      setTimeout ->
        next_item(items.shift())
      , 4

    next_item(items.shift())

  _handle_single_item: (i) =>
    data =
      media_item_id: i.value
      media_item:    i.text
    for j in ['begin_time', 'end_time', 'begin_date', 'end_date', 'playbacks_per_day']
      data[j] = $("#mediaitems-#{@type}-#{j}-textbox").val()

    $("#add-nested-#{@type}").trigger('click', [data])


class SetPlaylistItemValues
  constructor: (@type, @added_index, @data) ->
  call: =>
    for i in ['media_item', 'media_item_id', 'begin_time', 'end_time', 'begin_date', 'end_date', 'playbacks_per_day']
      val = @data[i]
      @_set_attribute_value(i, val)
    if @type == 'background'
      @_set_attribute_value('position', @added_index)

  _set_attribute_value: (attr, value) =>
    input_value = $("#playlist_playlist_items_#{@type}_attributes_#{@added_index}_#{attr}")
    input_value.val(value)


class PlaybacksPerHour
  constructor: (@begin_time, @end_time, @prd, @prh) ->
    $(@prh).change =>
      hours = @_recalc()
      @_set_prd(hours)

    $(@prd).change =>
      hours = @_recalc()
      @_set_prh(hours)

    $(@end_time).change =>
      hours = @_recalc()
      @_set_prh(hours)

    $(@begin_time).change =>
      hours = @_recalc()
      @_set_prh(hours)

  _set_prh: (hours) =>
    $(@prh).val(Math.round(+$(@prd).val() / hours))

  _set_prd: (hours) =>
    $(@prd).val(hours * +$(@prh).val())

  _recalc: =>
    end = moment($(@end_time).val(), 'HH:mm:ss')
    begin = moment($(@begin_time).val(), 'HH:mm:ss')
    dur = moment.duration(end.diff(begin))
    Math.round(dur.asHours())


$(document).on 'fields_added.nested_form_fields', (event, param) ->
  type = null
  switch param.object_class
    when 'playlist_items_background'
      type = 'background'
    when 'playlist_items_advertising'
      type = 'advertising'
  (new SetPlaylistItemValues(type, param.added_index, param.additional_data)).call() if type
  setup_datetimeppicker()
  setup_shuffle_checkbox()


setup_multiselect = ->
  for i in ['advertising', 'background']
    new MultiselectButton(i)


setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY', locale: I18n?.locale || 'en')


setup_shuffle_checkbox = ->
  checkbox = $('#playlists-shuffle-checkbox')
  positions = $('.playlist_item_background-position')
  if checkbox.prop('checked')
    positions.prop('readonly', true)
  checkbox.click ->
    positions.prop('readonly', @checked)


ready = ->
  setup_datetimeppicker()
  setup_multiselect()
  setup_shuffle_checkbox()
  new PlaybacksPerHour('#mediaitems-advertising-begin_time-textbox',
                       '#mediaitems-advertising-end_time-textbox',
                       '#mediaitems-advertising-playbacks_per_day-textbox',
                       '#mediaitems-advertising-playbacks_per_hour-textbox')

$(document).on('turbolinks:load', ready)
