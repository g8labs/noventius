(function(){

  var FORM_SELECTOR = '#filter-form';

  function submitWithFormat(form, event, format) {
    event.preventDefault();
    event.stopPropagation();

    form.find('input[name=format]').val(format);
    form.submit();
  }

  $(function() {
    var $form = $(FORM_SELECTOR);
    if ($form.length > 0) {
      $form.validate({
        errorClass: 'has-error has-feedback',
        validClass: 'has-success has-feedback',
        errorPlacement: function(error, element) {
          $error = $(error);
          $element = $(element);
          $(error).addClass('control-label');
          $element.closest('.form-group').append(error);
        },
        rules: VALIDATIONS['rules'],
        messages: VALIDATIONS['messages']
      });

      $form.on('click', 'input[name=commit]', function(e) {
        submitWithFormat($form, e, 'html');
      });

      $form.on('click', '.download', function(e) {
        submitWithFormat($form, e, 'csv');
      });
    }
  });

})();
