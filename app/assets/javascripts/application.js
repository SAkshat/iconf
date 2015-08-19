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

function StatusHandler(args) {
  this.$container = $('body');
  this.$toggleButtonClass = args.toggleButtonClass;
  this.$flashMessageContainer = this.$container.find('#' + args.flashMessageContainerId);
  this.init()
};

StatusHandler.prototype.init = function() {
  this.bindEvents();
}

StatusHandler.prototype.bindEvents = function() {
  var _this = this
  this.$container.on('ajax:success', '.' + this.$toggleButtonClass ,function (evt, data, status, xhr) {
    if(data.invalid)
      _this.display_flash_message(data.type, false, data.failure_action);
    else
      _this.toggleStatus(this, data);
  })
}

StatusHandler.prototype.display_flash_message = function(object, result, action) {
  var flashMessagetext = result ? ' successfully ' : ' could not be ';
  var flashMessageClass = result ? ' alert-success' : ' alert-danger';
  this.$flashMessageContainer.empty().text(object + flashMessagetext + action).removeClass().addClass('fade in alert' + flashMessageClass);
  this.createAndAddDismissButton();
}

StatusHandler.prototype.createAndAddDismissButton = function() {
  var dismissButton = $('<button/>',
                            {
                              text: 'x',
                              class: 'close',
                              click: function() { $(this).closest('div').removeClass().empty(); }
                            });
  this.$flashMessageContainer.append(dismissButton);
}

StatusHandler.prototype.toggleStatus = function(button, data) {
  if(data.enabled)
    $(button).text('DISABLE').addClass('btn-primary').removeClass('btn-success').attr('href', data.link)
  else
    $(button).text('ENABLE').addClass('btn-success').removeClass('btn-primary').attr('href', data.link)
  this.display_flash_message(data.type, true, data.success_action)
}

$(document).ready(function() {
  args = { toggleButtonClass : 'toggle', flashMessageContainerId : 'flash_messages' };
  var toggle_status = new StatusHandler(args);
});
