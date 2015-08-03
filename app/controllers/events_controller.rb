class EventsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update]
  before_action :set_creator, only: [:new, :edit, :create, :update]
  before_action :check_event_is_upcoming, only: [:edit, :update]

  def index
    case params[:filter]
    when 'my_events'
      @events = current_user.events.enabled.order_by_start_date
    when 'attending_events'
      # To Do: Change where clause. Dont use string.
      @events = Event.where('id in (?)', current_user.discussions.enabled.pluck(:event_id).uniq).order_by_start_date
    else
      @events = Event.enabled.order_by_start_date
    end
  end

  def show
    @discussions = @event.discussions.order_by_start_date_time
  end

  def new
    @event = @creator.events.build
    @address = @event.build_address
    @contact_detail = @event.build_contact_detail
  end

  def edit
    @address = @event.address
    @contact_detail = @event.contact_detail
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.update(event_params)
        format.html {
          flash[:success] = 'Event successfully created'
          redirect_to @event
        }
      else
        format.html {
          flash.now[:error] = 'Event creation failed'
          render :new
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html {
          flash[:success] = 'Event successfully updated'
          redirect_to @event
        }
      else
        format.html {
          flash.now[:error] = 'Unable to edit event'
          render :edit
        }
      end
    end
  end

  private

    def check_event_is_upcoming
      unless @event.upcoming?
        redirect_to events_path, alert: 'The event cannot be edited'
      end
    end

    def set_creator
      @creator = current_user
      redirect_to events_path, alert: 'Couldn\'t find the required User' unless @creator
    end

    def set_event
      @event = Event.find_by(id: params[:id])
      redirect_to events_path, alert: 'Couldn\'t find the required event' unless @event
    end

    def event_params
      params.require(:event).permit(:creator_id, :name, :start_date, :end_date, :description, :logo, :enabled, address_attributes: [:id, :street, :city, :country, :zipcode], contact_detail_attributes: [:id, :phone_number, :email])
    end

end
