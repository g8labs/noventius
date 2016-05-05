// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){

  var FORM_SELECTOR = '#filter-form';

  $(document).on('ready page:load', function(){

    $(FORM_SELECTOR).validate({
      errorClass: 'has-error has-feedback',
      validClass: 'has-success has-feedback',
      errorPlacement: function(error, element) {
        $error = $(error);
        $element = $(element);
        $(error).addClass('control-label');
        $element.parent().append(error);
      },
      rules: VALIDATIONS['rules'],
      messages: VALIDATIONS['messages']
    });

  });

})();
