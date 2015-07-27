class EventsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update]
  before_action :set_creator, only: [:new, :edit, :create, :update]
  before_action :check_event_is_upcoming, only: [:edit, :update]

  def index
    if params[:user_id]
      @events = User.find_by_id(params[:user_id]).events.enabled.order_by_date
    else
      @events = Event.enabled.order_by_date
    end
  end

  def show
    @discussions = @event.discussions
  end

  def new
    if params[:user_id]
      @event = User.find_by_id(params[:user_id]).events.build
    else
      @event = Event.new
    end
    @address = @event.build_address
    @contact_detail = @event.build_contact_detail
  end

  def edit
    @address = @event.address
    @contact_detail = @event.contact_detail
  end

  def create
    @event = Event.new(p event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event successfully created' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event , notice: 'Event successfully updated' }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def check_event_is_upcoming
      unless @event.upcoming?
        redirect_to events_path, notice: 'The event cannot be edited'
      end
    end

    def set_creator
      @creator = User.find_by_id(current_user.id)
      redirect_to events_path, alert: 'Couldn\'t find the required User' unless @creator
    end

    def set_event
      @event = Event.find_by_id(params[:id])
      redirect_to events_path, alert: 'Couldn\'t find the required event' unless @event
    end

    def event_params
      params.require(:event).permit(:creator_id, :name, :start_date, :end_date, :description, :logo, :enabled, address_attributes: [:id, :street, :city, :country, :zipcode], contact_detail_attributes: [:id, :phone_number, :email])
    end

end
