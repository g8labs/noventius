// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  $("[type='date']").datetimepicker({
    format: 'DD/MM/YYYY'
  });

  $("[type='datetime']").datetimepicker({
    format: 'DD/MM/YYYY HH:mm',
    sideBySide: true
  });

});
