// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
jQuery(function($) {
  // when the #country field changes
  $("#message_channel_id").change(function() {
    // make a POST call and replace the content
    var channel = $('select#message_channel_id :selected').val();
    if(channel == "") channel="0";
    jQuery.get('/api/channels/get_programmes/' + channel, function(data){
        $("#programmeDiv").html(data);
    })
    return false;
  });

})
