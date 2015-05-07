# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  options = valueNames: [
    valueNames: ['filename', 'description']
    page: 1000
  ]
  userList = new List('media_items', options)
  
  $('#select-all-checkbox').click ->
    console.log("clicked select all")
    $('.media-item-checkbox').prop('checked', @checked)

$(document).ready(ready)
$(document).on('page:load', ready)