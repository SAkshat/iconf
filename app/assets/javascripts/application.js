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
//= require jquery
//= require jquery_ujs
//= require bootstrap.min

function Toggler() {

  var displayError = function() {
    alert("ajax error")
  }

  $('body').on('ajax:success','.toggle' ,function (evt, data, status, xhr) {
    if(data.enabled)
      $(this).text('DISABLE').addClass('btn-primary').removeClass('btn-success').attr('href', data.link)
    else
      $(this).text('ENABLE').addClass('btn-success').removeClass('btn-primary').attr('href', data.link)
  }).on('ajax:error', displayError)

};

$(document).ready(function() {
  var toggle_status = new Toggler()
});
