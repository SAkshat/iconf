class EventsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show, :search]
  before_action :load_event, only: [:show, :edit, :update]
  before_action :load_discussions, only: [:show, :edit, :update]
  before_action :set_discussions_speaker, only: [:create, :update]
  before_action :check_event_is_upcoming, only: [:edit, :update]

  def index
    case params[:filter]
    when 'my_events'
      @events = current_user.events.order(:start_time).includes(:address)
    when 'attending_events'
      @events = Event.includes(:address).where(id: current_user.discussions.enabled.pluck(:event_id).uniq).order(:start_time)
    else
      @events = Event.includes(:address).enabled_with_enabled_creator.order(:start_time)
    end
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
        format.html { redirect_to @event, flash: { success: 'Event successfully created' } }
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
        #SPEC
        format.html { redirect_to @event, flash: { success: 'Event successfully updated' } }
      else
        format.html {
          flash.now[:error] = 'Unable to edit event'
          render :edit
        }
      end
    end
  end

  def search
    if params[:keywords].blank?
      @events = Event.enabled_with_enabled_creator.order(:start_time)
    else
      @events = Event.enabled_with_enabled_creator.order(:start_time).search_keyword(params[:keywords])
    end
    render 'index'
  end

  private

    def load_discussions
      @discussions = @event.discussions.includes(:attendees).enabled.order(:date, :start_time)
    end

    def check_event_is_upcoming
      unless @event.upcoming?
        redirect_to events_path, alert: 'The event cannot be edited'
      end
    end

    def load_event
      @event = Event.find_by(id: params[:id])
      redirect_to events_path, alert: "Couldn't find the required event" unless @event
    end

    def set_discussions_speaker
      if params[:event][:discussions_attributes]
        params[:event][:discussions_attributes].each_pair do |k,v|
          if params[:event][:discussions_attributes][k][:speaker]
            params[:event][:discussions_attributes][k][:speaker_id] = User.find_by(email: v[:speaker]).try(:id)
          end
        end
      end
    end

    def event_params
      params.require(:event).permit(:creator_id, :name, :start_time, :end_time, :description, :logo, :logo_cache,
                                    :enabled, discussions_attributes: [:id, :name, :topic, :_destroy, :creator_id,
                                      :date, :start_time, :end_time, :description, :enabled, :location, :speaker_id],
                                    contact_detail_attributes: [:id, :phone_number, :email],
                                    address_attributes: [:id, :street, :city, :country, :zipcode])
    end

end
