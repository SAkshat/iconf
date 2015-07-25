class SessionsController < ApplicationController

  before_action :set_event, only: [:index, :show, :new, :edit, :create, :update]
  before_action :set_session, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @sessions = @event.sessions.where(status: true).order(:date, :start_time)
  end

  def show
  end

  def new
    @session = Session.new
  end

  def edit
  end

  def create
    @session = @event.sessions.new(session_params)
    respond_to do |format|
      if @session.save
        format.html { redirect_to Event.find_by(id: @session.event_id) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @event }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def set_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to events_path, alert: 'Couldn\'t find the required event' unless @event
    end

    def set_session
      @session = @event.sessions.find_by(id: params[:id])
      redirect_to event_sessions_path, alert: 'Couldn\'t find the required session' unless @session
    end

    def session_params
      params.require(:session).permit(:session_id, :name, :topic, :date, :start_time, :end_time, :description, :status, :location)
    end

end
