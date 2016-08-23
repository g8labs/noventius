(function(){

  var setDateTimePickerDate = function(el, val, format) {
    if(val) {
      var $el = $(el);
      var date = moment(val, format);

      $el.data('DateTimePicker').defaultDate(date);
    }
  };

  $(function() {
    $("input[data-type='date']").each(function (index, el) {
      var $el = $(el);
      var filterName = $el.attr('name');

      if(FILTERS[filterName]['options']['icon']) {
        $el = $el.parent();
      }
      $el.datetimepicker({ format: DATE_FORMAT });

      setDateTimePickerDate($el, FILTER_PARAMS[filterName], DATE_FORMAT);
    });

    $("input[data-type='datetime']").each(function (index, el) {
      var $el = $(el);
      var filterName = $el.attr('name');

      if(FILTERS[filterName]['options']['icon']) {
        $el = $el.parent();
      }
      $el.datetimepicker({ format: DATETIME_FORMAT, sideBySide: true });

      setDateTimePickerDate($el, FILTER_PARAMS[filterName], DATETIME_FORMAT);
    });

  });

})();
