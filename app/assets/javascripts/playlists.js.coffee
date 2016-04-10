# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  setup_datetimeppicker()

$(document).on 'fields_added.nested_form_fields', (event, param) ->
  setup_datetimeppicker()
  switch param.object_class
    when 'playlist_items_background'
      set_playlist_item_value_and_text('background', param.added_index)
    when 'playlist_items_advertising'
      set_playlist_item_value_and_text('advertising', param.added_index)

set_playlist_item_value_and_text = (type, added_index) ->
  value = $("#select_media_item_#{type}_id option:selected").val()
  text =  $("#select_media_item_#{type}_id option:selected").text()
  input_text =  $("#playlist_playlist_items_#{type}_attributes_#{added_index}_media_item")
  input_value = $("#playlist_playlist_items_#{type}_attributes_#{added_index}_media_item_id")
  input_text.val(text)
  input_value.val(value)

setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY')

$(document).ready(ready)
$(document).on('page:load', ready)
