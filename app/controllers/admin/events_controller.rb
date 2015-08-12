class Admin::EventsController < Admin::AdminController

  before_action :load_event, only: [:enable, :disable, :show]
  before_action :is_creator_enabled?, only: [:enable]

  def index
    @events = Event.order(:start_time)
  end

  def show
    # [DONE TODO - S] Why are we ordering by id? Needed a field in case the first two fields were the same
    @discussions = @event.discussions.order(:date, :start_time, :created_at)
  end

  def enable
    respond_to do |format|
      # [DONE TODO - S] Why using update_column?
      if @event.update_attributes(enabled: true)
        format.html { redirect_to :back, flash: { success: 'Event successfully enabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'Event could not be enabled' } }
      end
    end
  end

  def disable
    respond_to do |format|
      # [DONE TODO - S] Why using update_column?
      if @event.update_attributes(enabled: false)
        format.html { redirect_to :back, flash: { success: 'Event successfully disabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'Event could not be disabled' } }
      end
    end
  end

  private

    # [TODO - S] Should be a model validation.
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
