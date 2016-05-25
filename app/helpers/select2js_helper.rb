module Select2jsHelper
  # rubocop: disable Metrics/MethodLength
  def select2js_for_id(id)
    js = <<-JS
    (function() {
      $(document).on('turbolinks:before-cache', function() {
        elem = $('##{id}');
        if(elem.data('select2') !== undefined) {
          elem.select2('destroy');
        };
      });
      elem = $('##{id}');
      if(elem.data('select2') !== undefined) {
        return;
      };
      elem.select2({ width: '100%', theme: 'bootstrap' });
    })();
    JS
    javascript_tag(js)
  end
  # rubocop: enable Metrics/MethodLength
end
