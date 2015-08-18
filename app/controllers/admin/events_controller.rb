class Admin::EventsController < Admin::AdminController

  before_action :load_event, only: [:enable, :disable, :show]

  def index
    @events = Event.order(:start_time)
  end

  def show
    # [DONE TODO - S] Why are we ordering by id? Needed a field in case the first two fields were the same
    @discussions = @event.discussions.order(:date, :start_time, :created_at)
  end

  def enable
    respond_to do |format|
      # [DONE TODO - S] update_attribute will never return false.
      if @event.update(enabled: true)
        format.html { redirect_to :back, flash: { success: 'Event successfully enabled' } }
        format.json { render json: { enabled: true, link: disable_admin_event_path(@event) } }
      else
        format.html { redirect_to :back, flash: { error: 'Event could not be enabled' } }
        format.json
      end
    end
  end

  def disable
    respond_to do |format|
      # [DONE TODO - S] update_attributes will never return false.
      if @event.update(enabled: false)
        format.html { redirect_to :back, flash: { success: 'Event successfully disabled' } }
        format.json { render json: { enabled: false, link: enable_admin_event_path(@event) } }
      else
        format.html { redirect_to :back, flash: { error: 'Event could not be disabled' } }
        format.json
      end
    end
  end

  private

    # [DONE TODO - S] Should be a model validation.

    def load_event
      @event = Event.find_by(id: params[:id])
      redirect_to :back, alert: "Couldn't find the required Event" unless @event
    end

end
