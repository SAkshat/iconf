
function DynamicFieldsHandler(args) {
  this.$fieldContainer = $('#' + args.fieldContainerId);
  this.triggerButtonId = args.triggerButtonId;
  this.html_data = this.$fieldContainer.find('#' + args.data_store_id).data;
  this.init();
};

DynamicFieldsHandler.prototype.init = function() {
  this.bindEvents();
}

DynamicFieldsHandler.prototype.bindEvents = function() {
  var _this = this
  $('body').on('click', '#' + this.triggerButtonId ,function () {
  })
}

$(document).ready(function() {
  args = { fieldContainerId: 'discussions', triggerButtonId: 'add_discussion', data_store_id: 'discussion_data' };
  var dynamicDiscussionsHandler = new DynamicFieldsHandler(args);
});
