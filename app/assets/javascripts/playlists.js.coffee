# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  setup_select2js_for_nested_form()
  setup_datetimeppicker()

$(document).on 'fields_added.nested_form_fields', (event, param) ->
  setup_select2js_for_nested_form()
  setup_datetimeppicker()

setup_select2js_for_nested_form = ->
  $('.select-media-item').select2({ width: '100%', theme: 'bootstrap' })

setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY')

$(document).ready(ready)
$(document).on('page:load', ready)
