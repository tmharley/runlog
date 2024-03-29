# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('[data-toggle="tooltip"]').tooltip({
    container: 'body'
  })
  $('#start-date').datetimepicker({
    format: 'YYYY-MM-DD'
  });
  $('#end-date').datetimepicker({
    format: 'YYYY-MM-DD'
  });