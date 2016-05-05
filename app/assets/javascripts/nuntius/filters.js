// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){

  $(document).on('ready page:load', function(){

    // Initialize all DatePickers
    $("[type='date']").each(function (index, el) {
      var $el = $(el);
      var filterName = $el.attr('name');

      $el.datetimepicker({
        format: DATE_FORMAT,
      });

      setDateTimePickerDate(el, FILTER_PARAMS[filterName], DATE_FORMAT);
    });

    // Initialize all DateTimePickers
    $("[type='datetime']").each(function (index, el) {
      var $el = $(el);
      var filterName = $el.attr('name');

      $el.datetimepicker({
        format: DATETIME_FORMAT,
        sideBySide: true
      });

      setDateTimePickerDate(el, FILTER_PARAMS[filterName], DATETIME_FORMAT);
    });

  });

  var setDateTimePickerDate = function(el, val, format) {
    if(val) {
      var $el = $(el);
      var date = moment(val, format);

      $el.data('DateTimePicker').defaultDate(date);
    }
  };

})();
