module Select2jsHelper
  # rubocop: disable Metrics/MethodLength
  def select2js_for_id(id)
    js = <<-JS
    (function() {
      $(document).on('turbolinks:before-cache', function() {
        if($('##{id}').data('select2') !== undefined) {
          $('##{id}').select2('destroy');
        };
      });
      if($('##{id}').data('select2') !== undefined) {
        return;
      };
      $('##{id}').select2({ width: '100%', theme: 'bootstrap' });
    })();
    JS
    javascript_tag(js)
  end
  # rubocop: enable Metrics/MethodLength
end
