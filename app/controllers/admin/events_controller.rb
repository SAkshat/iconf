class Admin::EventsController < ApplicationController

  before_action :set_event, only: [:enable, :disable]

  def index
    @events = Event.all.order(:start_date)
  end

  def enable
    @event.enabled = true
    respond_to do |format|
     if @event.save
        format.html {
          flash[:success] = 'Event successfully enabled'
          redirect_to admin_events_path
        }
      else
        format.html {
          flash[:error] = 'Event could not be enabled'
          redirect_to admin_events_path
        }
      end
    end
  end

  def disable
    @event.enabled = false
    respond_to do |format|
      if @event.save
        format.html {
          flash[:success] = 'Event successfully disabled'
          redirect_to admin_events_path
        }
      else
        format.html {
          flash[:error] = 'Event could not be disabled'
          redirect_to admin_events_path
        }
      end
    end
  end

  private

    def set_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to admin_events_path, alert: 'Couldn\'t find the required Event' unless @event
    end

end
