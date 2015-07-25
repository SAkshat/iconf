class EventsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update]

  def index
    if params[:user_id]
      @events = User.find_by(id: params[:user_id]).events.where(status: true).order(:start_date)
    else
      @events = Event.where(status: true).order(:start_date)
    end
  end

  def show
    @sessions = @event.sessions
  end

  def new
    if params[:user_id]
      @event = User.find_by(id: params[:user_id]).events.build
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
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def set_event
      @event = Event.find_by(id: params[:id])
      redirect_to events_path, alert: 'Couldn\'t find the required event' unless @event
    end

    def event_params
      puts params
      params.require(:event).permit(:creator_id, :name, :start_date, :end_date, :description, :logo, :status, address_attributes: [:street, :city, :country, :zipcode], contact_detail_attributes: [:phone_number, :email])
    end

end
