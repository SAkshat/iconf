class Admin::DiscussionsController < Admin::AdminController

  before_action :load_event, only: [:enable, :disable]
  before_action :load_discussion, only: [:enable, :disable]
  before_action :is_session_editanle, only: [:update]

  def enable
    respond_to do |format|
      if @discussion.update(enabled: true)
        format.html { redirect_to :back, flash: { success: 'Discussion successfully enabled' } }
        format.json { render json: { enabled: true, link: disable_admin_event_discussion_path(@event, @discussion), type: :Discussion, success_action: :enabled } }
      else
        format.html { redirect_to :back, flash: { error: 'Discussion could not be enabled' } }
        format.json { render json: { invalid: true, type: :Discussion, failure_action: :enabled } }
      end
    end
  end

  def disable
    respond_to do |format|
      if @discussion.update(enabled: false)
        send_notification_email_to_attendees
        format.html { redirect_to :back, flash: { success: 'Discussion successfully disabled' } }
        format.json { render json: { enabled: false, link: enable_admin_event_discussion_path(@event, @discussion), type: :Discussion, success_action: :disabled } }
      else
        format.html { redirect_to :back, flash: { error: 'Discussion could not be disabled' } }
        format.json { render json: { invalid: true, type: :Discussion, failure_action: :enabled } }
      end
    end
  end

  private

    def load_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to :back, alert: "Couldn't find the required Event" unless @event
    end

    def load_discussion
      @discussion = @event.discussions.find_by(id: params[:id])
      redirect_to :back, alert: "Couldn't find the required Discussion" unless @discussion
    end

    def send_notification_email_to_attendees
      attendees = @discussion.attendees
      attendees.each do |attendee|
        if attendee.email?
          UserMailer.discussion_disable_email(attendee, @discussion).deliver_later
        end
      end
    end

end
