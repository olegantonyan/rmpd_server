# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  setup_list_background()
  setup_list_advertising()
  setup_shuffle_checkbox()

setup_list_background = ->
  options = {
    valueNames: ['filename', 'description', 'company']
    page: 1000
  }
  userList = new List('media-items-background', options)
  $('#select-all-background-checkbox').click ->
    $('.media-item-background-checkbox').prop('checked', @checked)

setup_list_advertising = ->
  options = {
    valueNames: ['filename', 'description', 'company']
    page: 1000
  }
  userList = new List('media-items-advertising', options)
  $('#select-all-advertising-checkbox').click ->
    $('.media-item-advertising-checkbox').prop('checked', @checked)

setup_shuffle_checkbox = ->
  if $('#playlists-shuffle-checkbox').attr('checked')
    $('.media-item-background-position').prop('readonly', true)
  $('#playlists-shuffle-checkbox').click ->
    $('.media-item-background-position').prop('readonly', @checked)

$(document).ready(ready)
$(document).on('page:load', ready)
