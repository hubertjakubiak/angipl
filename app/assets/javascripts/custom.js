$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});

 $(document).bind("ajaxSend", function(){
    $("#loading").css('visibility', 'visible');
 }).bind("ajaxComplete", function(){
    $("#loading").css('visibility', 'hidden');
 }).bind("ajaxError", function(){
    $("#loading").css('visibility', 'visible');
    $("#loading").html('<span class="label label-danger">Wystąpił błąd. Proszę odświeżyć stronę.</span>')
 });