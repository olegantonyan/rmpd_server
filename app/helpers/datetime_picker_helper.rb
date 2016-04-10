module DatetimePickerHelper
  def datetime_picker_for_id(id, format)
    javascript_tag "$(document).ready(function() { $('##{id}').datetimepicker({ format: '#{format}' }); });"
  end
end
