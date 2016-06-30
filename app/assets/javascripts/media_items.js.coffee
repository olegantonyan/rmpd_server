setup_ajax_fileupload = ->
  pending_files = []
  xhrs = []

  $('#submit-ajax-fileupload').click ->
    $('#submit-ajax-fileupload').addClass('hidden')
    $('#cancel-ajax-fileupload').removeClass('hidden')
    disable_form()
    xhrs = []
    for file in pending_files
      xhr = file.submit()
      xhrs.push(xhr)

  $('#cancel-ajax-fileupload').click ->
    for xhr in xhrs
      xhr.abort()

  $('#ajax-fileupload').fileupload
    maxChunkSize: 1000000
    sequentialUploads: true
    #limitConcurrentUploads: 3
    dataType: 'json'
    add: (e, data) ->
      pending_files.push(data)
      $('#submit-ajax-fileupload').removeClass('hidden')
      $('#uploaded-ajax-fileupload li').remove()
      set_progress(0)

    done: (e, data) ->
      $('#uploaded-ajax-fileupload').append("<li class='text-success'>#{[i.name for i in data.files]}</li>")
      pending_files.pop()
      if pending_files.length is 0
        set_upload_done()

    progressall: (e, data) ->
      progress = data.loaded / data.total * 100
      set_progress(progress)

    error: (e, data, error_t) ->
      if error_t is 'abort'
        set_upload_done()
        pending_files = []
        return
      $('#uploaded-ajax-fileupload').append("<li class='text-danger'>[ERROR] #{e?.responseJSON?.files or e.statusText}: #{e?.responseJSON?.error or e.responseText}</li>")
      pending_files.pop()
      if pending_files.length is 0
        set_upload_done()

set_upload_done = ->
  $('#cancel-ajax-fileupload').addClass('hidden')
  enable_form()

set_progress = (progress) ->
  pgbar = $('#progressall-ajax-fileupload')
  pgbar.css('width', "#{progress}%")
  pgbar.attr('aria-valuenow', progress)
  pgbar.text("#{Math.round(progress)}%")

disable_form = ->
  $("#ajax-fileupload input").prop('readonly', true)
  $('.fileinput-button').hide()

enable_form = ->
  $("#ajax-fileupload input").prop('readonly', false)
  $('.fileinput-button').show()

ready = ->
  setup_ajax_fileupload()

$(document).on('turbolinks:load', ready)
