
function DynamicFieldsHandler(args) {
  this.$container = $('#' + args.containerId);
  this.triggerButtonId = args.triggerButtonId;
  this.html_data = this.$container.find('#' + args.data_store_id).data;
  this.init()
};

DynamicFieldsHandler.prototype.init = function() {
  this.bindEvents();
}

DynamicFieldsHandler.prototype.bindEvents = function() {
  var _this = this
  this.$container.on('click', '.' + this.triggerButtonId ,function () {
    alert('hi');
  })
}

$(document).ready(function() {
  args = { containerId: 'discussions', triggerButtonId: 'add_discussion', data_store_id: 'discussion_data' };
  var dynamicDiscussionsHandler = new DynamicFieldsHandler(args);
});
