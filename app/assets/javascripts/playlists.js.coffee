class MultiselectButton
  constructor: (@type) ->
    $("#mediaitems-#{@type}-add-multiple-button").click =>
      @_handle_click()

  _handle_click: =>
    for i in $("#mediaitems-#{@type}-selectbox :selected")
      (new CurrentInputHandler(@type, 'media_item_id')).call(i.value)
      (new CurrentInputHandler(@type, 'media_item')).call(i.text)

      for j in ['begin_time', 'end_time', 'begin_date', 'end_date', 'playbacks_per_day']
        v = $("#mediaitems-#{@type}-#{j}-textbox").val()
        (new CurrentInputHandler(@type, j)).call(v)

      @_click_add_nested_button()

  _click_add_nested_button: =>
    $("#add-nested-#{@type}").click()


class CurrentInputHandler
  constructor: (@type, @attr) ->
  call: (value) =>
    (new SetCurrentValue("current-#{@type}-#{@attr}")).call(value)


class SetCurrentValue
  constructor: (@id) ->
  call: (value) =>
    $("##{@id}").val(value)


class SetPlaylistItemValues
  constructor: (@type, @added_index) ->
  call: =>
    for i in ['media_item', 'media_item_id', 'begin_time', 'end_time', 'begin_date', 'end_date', 'playbacks_per_day']
      val = @_get_attribute_value(i)
      @_set_attribute_value(i, val)
    if @type == 'background'
      @_set_attribute_value('position', @added_index)

  _get_attribute_value: (attr) =>
    $("#current-#{@type}-#{attr}").val()

  _set_attribute_value: (attr, value) =>
    input_value = $("#playlist_playlist_items_#{@type}_attributes_#{@added_index}_#{attr}")
    input_value.val(value)


$(document).on 'fields_added.nested_form_fields', (event, param) ->
  type = null
  switch param.object_class
    when 'playlist_items_background'
      type = 'background'
    when 'playlist_items_advertising'
      type = 'advertising'
  (new SetPlaylistItemValues(type, param.added_index)).call() if type
  setup_datetimeppicker()
  setup_shuffle_checkbox()


setup_multiselect = ->
  for i in ['advertising', 'background']
    new MultiselectButton(i)


setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY')


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

$(document).on('turbolinks:load', ready)
