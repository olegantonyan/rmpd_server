# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  setup_select_all()

setup_select_all = ->
  console.log('setting up select all js')
  $('#select-all-media_items-checkbox').click ->
    console.log("clicked select all")
    $('.media_item-checkbox').prop('checked', @checked)
  window.setup_select_all = setup_select_all # for index.js.erb

$(document).ready(ready)
$(document).on('page:load', ready)
