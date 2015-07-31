module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type.intern
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def errors_for(model, attribute)
    if model.errors[attribute].present?
      content_tag :div, :class => 'error_explanation' do
        '[ ' + model.errors[attribute].join(", ") + ' ]'
      end
    end
  end

end
