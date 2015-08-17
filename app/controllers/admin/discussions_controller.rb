class Admin::DiscussionsController < Admin::AdminController

  before_action :load_event, only: [:enable, :disable]
  before_action :load_discussion, only: [:enable, :disable]
  before_action :is_session_editanle, only: [:update]

  def enable
    respond_to do |format|
     # [DONE TODO - S] update_attribute will never return false.
     if @discussion.update_attributes(enabled: true)
        format.html { redirect_to :back, flash: { success: 'Discussion successfully enabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'Discussion could not be enabled' } }
      end
    end
  end

  def disable
    respond_to do |format|
      # [DONE TODO - S] update_attributes will never return false.
      if @discussion.update_attributes(enabled: false)
        format.html { redirect_to :back, flash: { success: 'Discussion successfully disabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'Discussion could not be disabled' } }
      end
    end
  end

  private

    # [DONE TODO - S] This should be a model validation.

    def load_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to :back, alert: "Couldn't find the required Event" unless @event
    end

    def load_discussion
      @discussion = @event.discussions.find_by(id: params[:id])
      redirect_to :back, alert: "Couldn't find the required Discussion" unless @discussion
    end

end
