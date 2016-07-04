setup_ajax_fileupload = ->
  console.log(I18n?.translations)
  pending_files = []
  xhrs = []
  submit_element = $('#submit-ajax-fileupload')
  cancel_element = $('#cancel-ajax-fileupload')

  submit_element.click ->
    (new HideableElement(submit_element)).hide()
    (new HideableElement(cancel_element)).show()
    (new Form).disable()
    xhrs = []
    for file in pending_files
      xhr = file.submit()
      xhrs.push(xhr)

  cancel_element.click ->
    for xhr in xhrs
      xhr.abort()

  $('#ajax-fileupload').fileupload
    maxChunkSize: 1000000
    sequentialUploads: true
    #limitConcurrentUploads: 3
    dataType: 'json'
    add: (e, data) ->
      pending_files.push(data)
      (new HideableElement(submit_element)).show()
      $('#uploaded-ajax-fileupload li').remove()
      (new Progress).set(0)
      $('#queued-ajax-fileupload').text(pending_files.length)

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
    (new HideableElement(cancel_element)).hide()
    (new Form).enable()
    $('#queued-ajax-fileupload').text(0)


class HideableElement
  constructor: (@element) ->

  hide: ->
    @element.addClass('hidden')

  show: ->
    @element.removeClass('hidden')


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
    @fileinput_element = $('#fakefileinput-button') # $('.fileinput-button')

  enable: ->
    @form_element.prop('readonly', false)
    @fileinput_element.show()

  disable: ->
    @form_element.prop('readonly', true)
    @fileinput_element.hide()


ready = ->
  setup_ajax_fileupload()

$(document).on('turbolinks:load', ready)
