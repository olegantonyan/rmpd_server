# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class SelectMultipleMediaItems
  constructor: (@textbox_id, @selectbox_id, @button_id, @onselected_element_id, @current_value_id, @current_text_id) ->
    $("##{@selectbox_id}").filterByText($("##{@textbox_id}"), true)
    $("##{@button_id}").click =>
      @onclick()

  onclick: ->
    for i in $("##{@selectbox_id} :selected")
      @append(i.value, i.text)

  append: (value, text) ->
    $("##{@current_value_id}").val(value)
    $("##{@current_text_id}").val(text)
    $("##{@onselected_element_id}").click()


ready = ->
  setup_datetimeppicker()
  for i in ['advertising', 'background']
    new SelectMultipleMediaItems("filter-mediaitems-#{i}-textbox",
                                 "mediaitems-#{i}-selectbox",
                                 "mediaitems-#{i}-add-multiple-button",
                                 "add-nested-#{i}",
                                 "current-#{i}-mediaitem_id"
                                 "current-#{i}-mediaitem")

$(document).on 'fields_added.nested_form_fields', (event, param) ->
  setup_datetimeppicker()
  switch param.object_class
    when 'playlist_items_background'
      set_playlist_item_value_and_text('background', param.added_index)
    when 'playlist_items_advertising'
      set_playlist_item_value_and_text('advertising', param.added_index)

set_playlist_item_value_and_text = (type, added_index) ->
  value = $("#current-#{type}-mediaitem_id").val()
  text =  $("#current-#{type}-mediaitem").val()
  input_text =  $("#playlist_playlist_items_#{type}_attributes_#{added_index}_media_item")
  input_value = $("#playlist_playlist_items_#{type}_attributes_#{added_index}_media_item_id")
  input_text.val(text)
  input_value.val(value)

setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY')

$(document).ready(ready)
$(document).on('page:load', ready)
