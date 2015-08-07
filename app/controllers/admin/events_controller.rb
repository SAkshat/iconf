class Admin::EventsController < AdminController

  before_action :load_event, only: [:enable, :disable, :show]
  before_action :is_creator_enabled?, only: [:enable]

  def index
    @events = Event.order(:start_time)
  end

  def show
    @discussions = @event.discussions.order(:date, :start_time, :id)
  end

  def enable
    respond_to do |format|
     if @event.update_column(:enabled, true)
        format.html { redirect_to :back, flash: { success: 'Event successfully enabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'Event could not be enabled' } }
      end
    end
  end

  def disable
    respond_to do |format|
     if @event.update_column(:enabled, false)
        format.html { redirect_to :back, flash: { success: 'Event successfully disabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'Event could not be disabled' } }
      end
    end
  end

  private

    def is_creator_enabled?
      @creator = @event.creator
      if !@creator.enabled?
        redirect_to :back, flash: { error: "Creator #{ @creator.name } is disabled. Event cannot be enabled." }
      end
    end

    def load_event
      @event = Event.find_by(id: params[:id])
      redirect_to :back, alert: "Couldn't find the required Event" unless @event
    end

end
