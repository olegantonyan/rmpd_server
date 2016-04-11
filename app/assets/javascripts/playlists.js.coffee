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
      @_set_attribute_value(i)

  _set_attribute_value: (attr) =>
    value = $("#current-#{@type}-#{attr}").val()
    input_value = $("#playlist_playlist_items_#{@type}_attributes_#{@added_index}_#{attr}")
    input_value.val(value)


$(document).on 'fields_added.nested_form_fields', (event, param) ->
  setup_datetimeppicker()
  type = null
  switch param.object_class
    when 'playlist_items_background'
      type = 'background'
    when 'playlist_items_advertising'
      type = 'advertising'
  if type and param.added_index
    (new SetPlaylistItemValues(type, param.added_index)).call()


setup_multiselect = ->
  for i in ['advertising', 'background']
    new MultiselectButton(i)


setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY')


ready = ->
  setup_datetimeppicker()
  setup_multiselect()


$(document).ready(ready)
$(document).on('page:load', ready)
