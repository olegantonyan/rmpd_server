# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

toggle_playlist_form = ->
  if $('#create-playlist-checkbox').is(':checked')
    $('#playlist-form').show()
  else
    $('#playlist-form').hide()

ready = ->
  toggle_playlist_form()
  $('#create-playlist-checkbox').click ->
    toggle_playlist_form()
    
$(document).ready(ready)
$(document).on('page:load', ready)