class Admin::DiscussionsController < ApplicationController

  before_action :load_event, only: [:index, :enable, :disable, :show]
  before_action :load_discussion, only: [:enable, :disable]

  def index
    @discussions = Discussion.all.order(:id)
  end

  def show
    @discussion = @event.find_by(id: params[:id])
  end

  def enable
    respond_to do |format|
     if @discussion.update_attribute(:enabled, true)
        format.html { redirect_to admin_event_path(@event), success: 'Discussion successfully enabled' }
      else
        format.html { redirect_to admin_event_path(@event), error: 'Discussion could not be enabled' }
      end
    end
  end

  def disable
    respond_to do |format|
     if @discussion.update_attribute(:enabled, false)
        format.html { redirect_to admin_event_path(@event), success: 'Discussion successfully disabled' }
      else
        format.html { redirect_to admin_event_path(@event), error: 'Discussion could not be disabled' }
      end
    end
  end

  private

    def load_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to admin_events_path, alert: "Couldn't find the required Event" unless @event
    end

    def load_discussion
      @discussion = @event.discussions.find_by(id: params[:id])
      redirect_to admin_event_path(@event), alert: "Couldn't find the required Discussion" unless @discussion
    end

end
