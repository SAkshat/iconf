class Admin::EventsController < AdminController

  before_action :load_event, only: [:enable, :disable]

  def index
    @events = Event.all.order(:start_time)
  end

  def show
    @event = Event.find_by(id: params[:id])
    @discussions = @event.discussions.order(:date, :start_time, :id)
  end

  def enable
    respond_to do |format|
     if @event.update_attribute(:enabled, true)
        format.html { redirect_to admin_events_path, success: 'Event successfully enabled' }
      else
        format.html { redirect_to admin_events_path, flash: { error: 'Event could not be enabled' } }
      end
    end
  end

  def disable
    respond_to do |format|
     if @event.update_attribute(:enabled, false)
        format.html { redirect_to admin_events_path, success: 'Event successfully disabled' }
      else
        format.html { redirect_to admin_events_path, flash: { error: 'Event could not be disabled' } }
      end
    end
  end

  private

    def load_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to admin_events_path, alert: "Couldn't find the required Event" unless @event
    end

end
