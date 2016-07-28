$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});

 $(document).bind("ajaxSend", function(){
   $("#loading").css('visibility', 'visible');
 }).bind("ajaxComplete", function(){
   $("#loading").css('visibility', 'hidden');
 }).bind("ajaxError", function(){
   $("#loading").html('Wystąpił błąd. Przeładuj stronę.')
 });