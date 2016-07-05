class MultiselectButton
  constructor: (@type) ->
    $("#mediaitems-#{@type}-add-multiple-button").click =>
      @_handle_click()

  _handle_click: =>
    items = $("#mediaitems-#{@type}-selectbox :selected").toArray()

    next_item = (i) =>
      return unless i
      @_handle_single_item(i)
      setTimeout ->
        next_item(items.shift())
      , 4

    next_item(items.shift())

  _handle_single_item: (i) =>
    data =
      media_item_id: i.value
      media_item:    i.text
    for j in ['begin_time', 'end_time', 'begin_date', 'end_date', 'playbacks_per_day']
      data[j] = $("#mediaitems-#{@type}-#{j}-textbox").val()

    $("#add-nested-#{@type}").trigger('click', [data])


class SetPlaylistItemValues
  constructor: (@type, @added_index, @data) ->
  call: =>
    for i in ['media_item', 'media_item_id', 'begin_time', 'end_time', 'begin_date', 'end_date', 'playbacks_per_day']
      val = @data[i]
      @_set_attribute_value(i, val)
    if @type == 'background'
      @_set_attribute_value('position', @_max_background_position() + 1)
    # @_set_midnight_rollover()

  _set_attribute_value: (attr, value) =>
    input_value = $("#playlist_playlist_items_#{@type}_attributes_#{@added_index}_#{attr}")
    input_value.val(value)

  _max_background_position: () ->
    positions_elements = $(".playlist_item_background-position:visible")
    max_value = 0
    positions_elements.each ->
      value = +$(this).val()
      max_value = value if value > max_value
    max_value

  _set_midnight_rollover: ->
    new MidnightRollover("#playlist_playlist_items_#{@type}_attributes_#{@added_index}_begin_time", "#playlist_playlist_items_#{@type}_attributes_#{@added_index}_end_time")

class PlaybacksPerHour
  constructor: (@begin_time, @end_time, @prd, @prh) ->
    $(@prh).change =>
      hours = @_recalc()
      @_set_prd(hours)

    $(@prd).change =>
      hours = @_recalc()
      @_set_prh(hours)

    $(@end_time).change =>
      hours = @_recalc()
      @_set_prh(hours)

    $(@begin_time).change =>
      hours = @_recalc()
      @_set_prh(hours)

  _set_prh: (hours) =>
    $(@prh).val(Math.round(+$(@prd).val() / hours))

  _set_prd: (hours) =>
    $(@prd).val(hours * +$(@prh).val())

  _recalc: =>
    end = moment($(@end_time).val(), 'HH:mm:ss')
    begin = moment($(@begin_time).val(), 'HH:mm:ss')
    dur = moment.duration(end.diff(begin))
    Math.round(dur.asHours())


$(document).on 'fields_added.nested_form_fields', (event, param) ->
  type = null
  switch param.object_class
    when 'playlist_items_background'
      type = 'background'
    when 'playlist_items_advertising'
      type = 'advertising'
  (new SetPlaylistItemValues(type, param.added_index, param.additional_data)).call() if type
  setup_datetimeppicker()
  setup_shuffle_checkbox()


setup_multiselect = ->
  for i in ['advertising', 'background']
    new MultiselectButton(i)


setup_datetimeppicker = ->
  $('.datetime-picker-time').datetimepicker(format: 'HH:mm:ss')
  $('.datetime-picker-date').datetimepicker(format: 'DD.MM.YYYY', locale: I18n?.locale || 'en', showClear: true, showClose: true)


setup_shuffle_checkbox = ->
  checkbox = $('#playlists-shuffle-checkbox')
  positions = $('.playlist_item_background-position')
  if checkbox.prop('checked')
    positions.prop('readonly', true)
  checkbox.click ->
    positions.prop('readonly', @checked)


setup_midnight_rollover = ->
  new MidnightRollover('#mediaitems-advertising-begin_time-textbox', '#mediaitems-advertising-end_time-textbox')
  new MidnightRollover('#mediaitems-background-begin_time-textbox', '#mediaitems-background-end_time-textbox')

  for type in ['advertising', 'background']
    rows = $("##{type}-items-table tr").length
    for i in [0 ... rows - 1] by 1
      new MidnightRollover("#playlist_playlist_items_#{type}_attributes_#{i}_begin_time", "#playlist_playlist_items_#{type}_attributes_#{i}_end_time")

class Collapseable
  constructor: (@trigger_selector, @aria_selector) ->
    @shown_class = 'btn-default'
    @collapsed_class = 'btn-info'
    $(@aria_selector).on 'shown.bs.collapse', =>
      $(@trigger_selector).removeClass(@collapsed_class)
      $(@trigger_selector).addClass(@shown_class)

    $(@aria_selector).on 'hidden.bs.collapse', =>
      $(@trigger_selector).removeClass(@shown_class)
      $(@trigger_selector).addClass(@collapsed_class)


class MidnightRollover
  constructor: (begin_time_selector, end_time_selector) ->
    @begin_time = $(begin_time_selector)
    @end_time = $(end_time_selector)

    @begin_time.on 'dp.change', =>
      @_changed()
    @end_time.on 'dp.change', =>
      @_changed()

  _changed: ->
    end = moment(@end_time.val(), 'HH:mm:ss')
    begin = moment(@begin_time.val(), 'HH:mm:ss')
    # if begin > end
      # TODO


ready = ->
  setup_datetimeppicker()
  setup_multiselect()
  setup_shuffle_checkbox()
  # setup_midnight_rollover()
  new PlaybacksPerHour('#mediaitems-advertising-begin_time-textbox',
                       '#mediaitems-advertising-end_time-textbox',
                       '#mediaitems-advertising-playbacks_per_day-textbox',
                       '#mediaitems-advertising-playbacks_per_hour-textbox')

  new Collapseable('#background-items-collapse-button', '#background-items')
  new Collapseable('#advertising-items-collapse-button', '#advertising-items')

$(document).on('turbolinks:load', ready)
