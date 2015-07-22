class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update]

  def index
    @events = Event.all.order(:start_date).where(status: true)
  end

  def show
  end

  def new
    @event = Event.new
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

  def destroy
    @event = Event.find_by(id: params[:id])
  end

  private

    def set_event
      @event = Event.find_by(id: params[:id])
      redirect_to events_path, alert: 'Couldn\'t find the required event' unless @event
    end

    def event_params
      x = params.require(:event).permit(:name, :start_date, :end_date, :description, :logo, :status, address_attributes: [:street, :city, :country, :zipcode], contact_detail_attributes: [:phone_number, :email])
    end

end
