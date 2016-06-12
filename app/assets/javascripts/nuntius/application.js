// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require moment/min/moment-with-locales.min
//= require moment-timezone/builds/moment-timezone-with-data.min
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
//= require jquery-validation/dist/jquery.validate.min
//= require jquery-validation/dist/additional-methods.min
//= require highlight-js/src/highlight

//= require_self
//= require nuntius/reports

var DATE_FORMAT = 'DD/MM/YYYY';
var DATETIME_FORMAT = 'DD/MM/YYYY HH:mm';

(function() {

  // Initialize syntax highlighting. This is used for SQL
  hljs.initHighlightingOnLoad();

  $.validator.addMethod('date', function(value, element) {
    return this.optional( element ) || moment(value, DATE_FORMAT, true).isValid();
  });

  $.validator.addMethod('datetime', function(value, element) {
    return this.optional( element ) || moment(value, DATETIME_FORMAT, true).isValid();
  });

})();
