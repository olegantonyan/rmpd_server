module Select2jsHelper
  def select2js_for_id(id)
    javascript_tag "$(document).ready(function() { $('##{id}').select2({ width: '100%', theme: 'bootstrap' }); });"
  end
end