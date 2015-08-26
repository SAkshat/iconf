
function DynamicFieldsHandler(args) {
  this.$fieldContainer = $('#' + args.fieldContainerId);
  this.$triggerButton = this.$fieldContainer.find('#' + args.triggerButtonId);
  this.$dataStoreContainer = this.$fieldContainer.find('#' + args.data_store_id);
  this.html_data = this.$dataStoreContainer.html();
  this.init();
};

DynamicFieldsHandler.prototype.init = function() {
  this.$dataStoreContainer.remove();
  this.bindEvents();
}

DynamicFieldsHandler.prototype.bindEvents = function() {
  var _this = this
  this.$triggerButton.on('click', function() {
    _this.create_and_append_div();
  })
}

DynamicFieldsHandler.prototype.create_and_append_div = function(){
  this.$fieldContainer.prepend('<div>' + this.create_dynamic_field() + '</div>');
}

DynamicFieldsHandler.prototype.create_dynamic_field = function() {
  return field_html = this.create_unique_html();
}

DynamicFieldsHandler.prototype.create_unique_html = function(){
  unique_integer = Date.now();
  html_data = this.html_data.replace(/_1_/g, '_' + unique_integer + '_');
  return html_data.replace(/\[\d+\]/g, '[' + unique_integer + ']');
}

$(document).ready(function() {
  args = { fieldContainerId: 'discussions-container', triggerButtonId: 'create-discussion', data_store_id: 'discussion-data-store' };
  var dynamicDiscussionsHandler = new DynamicFieldsHandler(args);
});
