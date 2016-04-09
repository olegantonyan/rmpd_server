# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  #setup_select_all()

setup_select_all = ->
  $('#select-all-background-checkbox').click ->
    $('.media-item-background-checkbox').prop('checked', @checked)
  $('#select-all-advertising-checkbox').click ->
    $('.media-item-advertising-checkbox').prop('checked', @checked)
  window.setup_select_all = setup_select_all # for index.js.erb

$(document).ready(ready)
$(document).on('page:load', ready)
