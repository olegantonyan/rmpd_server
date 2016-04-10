# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  setup_datetimeppicker()

$(document).on 'fields_added.nested_form_fields', (event, param) ->
  setup_datetimeppicker()
  switch param.object_class
    when 'playlist_items_background'
      value = $("#select_media_item_background_id option:selected").val()
      text = $("#select_media_item_background_id option:selected").text()
      input_text =  $("#playlist_playlist_items_background_attributes_#{param.added_index}_media_item")
      input_value = $("#playlist_playlist_items_background_attributes_#{param.added_index}_media_item_id")
      input_text.val(text)
      input_value.val(value)
    when 'playlist_items_advertising'
      value = $("#select_media_item_advertising_id option:selected").val()
      text = $("#select_media_item_advertising_id option:selected").text()
      input_text =  $("#playlist_playlist_items_advertising_attributes_#{param.added_index}_media_item")
      input_value = $("#playlist_playlist_items_advertising_attributes_#{param.added_index}_media_item_id")
      input_text.val(text)
      input_value.val(value)

setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY')

$(document).ready(ready)
$(document).on('page:load', ready)
