
function CloseButtonHandler(args) {
  this.$parentContainer = $('body');
  this.containerClass = args.containerClass
  this.closeButtonClass = args.closeButtonClass;
  this.init();
};

CloseButtonHandler.prototype.init = function() {
  this.bindEvents();
}

CloseButtonHandler.prototype.bindEvents = function() {
  _this = this
  this.$parentContainer.on('click', '.' + args.closeButtonClass, function(event) {
    $(event.target).closest('.' + _this.containerClass).remove()
  })
}

$(document).ready(function() {
  args = { closeButtonClass: 'close', containerClass: 'discussion-container' };
  var closeButton = new CloseButtonHandler(args);
});
