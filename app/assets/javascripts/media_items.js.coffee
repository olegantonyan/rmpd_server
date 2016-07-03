setup_ajax_fileupload = ->
  pending_files = []
  xhrs = []

  $('#submit-ajax-fileupload').click ->
    $('#submit-ajax-fileupload').addClass('hidden')
    $('#cancel-ajax-fileupload').removeClass('hidden')
    (new Form).disable()
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
      (new Progress).set(0)
      for i in pending_files
        console.log(i)

    done: (e, data) ->
      $('#uploaded-ajax-fileupload').append("<li class='text-success'>#{[i.name for i in data.files]}</li>")
      pending_files.pop()
      if pending_files.length is 0
        set_upload_done()

    progressall: (e, data) ->
      progress = data.loaded / data.total * 100
      (new Progress).set(progress)

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
  (new Form).enable()


class AjaxFileupload
  constructor: ->
    @submit_element = $('#submit-ajax-fileupload')
    @cancel_element = $('#cancel-ajax-fileupload')
    @form_element = $('#ajax-fileupload')


class Progress
  constructor: ->
    @progressbar_element = $('#progressall-ajax-fileupload')

  set: (progress) ->
    @progressbar_element.css('width', "#{progress}%")
    @progressbar_element.attr('aria-valuenow', progress)
    @progressbar_element.text("#{Math.round(progress)}%")


class Form
  constructor: ->
    @form_element = $("#ajax-fileupload input")
    @fileinput_element = $('.fileinput-button')

  enable: ->
    @form_element.prop('readonly', false)
    @fileinput_element.show()

  disable: ->
    @form_element.prop('readonly', true)
    @fileinput_element.hide()


ready = ->
  setup_ajax_fileupload()

$(document).on('turbolinks:load', ready)
