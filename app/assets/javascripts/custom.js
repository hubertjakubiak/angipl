$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();

    $( "#show_answers" ).click(function() {
      $( ".answers" ).show();
      $(this).remove();
    });
});

 $(document).bind("ajaxSend", function(){
    $("#loading").css('visibility', 'visible');
 }).bind("ajaxComplete", function(){
    $("#loading").css('visibility', 'hidden');
 }).bind("ajaxError", function(){
    $("#error-loading").html('<span class="label label-danger">Wystąpił błąd. Proszę odświeżyć stronę.</span>')
 });