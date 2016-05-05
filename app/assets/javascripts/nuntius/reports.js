// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function(){

  var DATE_FORMAT = 'DD/MM/YYYY';
  var DATETIME_FORMAT = 'DD/MM/YYYY HH:mm';

  var setDateTimePickerDate = function(el, val, format) {
    console.log(val);
    if(val) {
      var $el = $(el);
      var date = moment(val, format)

      $el.data('DateTimePicker').defaultDate(date)
    }
  };

  $(document).ready(function() {

    $("[type='date']").each(function (index, el) {
      var $el = $(el);
      var elId = $el.attr('id').replace('q_', '');

      $el.datetimepicker({
        format: DATE_FORMAT,
      });

      setDateTimePickerDate(el, filter_params[elId], DATE_FORMAT);
    });

    $("[type='datetime']").each(function (index, el) {
      var $el = $(el);
      var elId = $el.attr('id').replace('q_', '');

      $el.datetimepicker({
        format: DATETIME_FORMAT,
        sideBySide: true
      });

      setDateTimePickerDate(el, filter_params[elId], DATETIME_FORMAT);
    });

  });

})();
