
function FormHandler(args) {
  this.$container = $('.' + args.containerClass);
  this.$triggerButton = this.$container.find('#' + args.triggerButtonId);
  this.init()
};

FormHandler.prototype.init = function() {
  this.bindEvents();
}

FormHandler.prototype.bindEvents = function() {
  var _this = this
  this.$triggerButton.on('click', function () {
    if($(this).is(':checked'))
      _this.hideContainer(this);
    else
      _this.showContainer(this);
  })
}

FormHandler.prototype.hideContainer = function(trigger) {
  $(trigger).siblings('div').first().slideUp();
}

FormHandler.prototype.showContainer = function(trigger) {
  $(trigger).siblings('div').first().slideDown();
}

$(document).ready(function() {
  args = { containerClass: 'discussion-container', triggerButtonId: 'remove-discussion' };
  var discussionHandler = new FormHandler(args);
});
