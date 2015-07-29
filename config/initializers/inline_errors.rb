ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag !~ /^\<label/
    %(#{ html_tag }
      <div class="control-label red">
        #{ instance.error_message.join(', ') }
      </div>
    ).html_safe
  else
    html_tag
  end
end
