class DiscussionsController < ApplicationController

  before_action :set_event, only: [:index, :show, :new, :edit, :create, :update]
  before_action :set_creator, only: [:new, :edit, :create, :update]
  before_action :set_discussion, only: [:show, :edit, :update]
  before_action :check_if_discussion_is_upcoming, only: [:edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @discussions = @event.discussions.enabled.order_by_start_date_time
  end

  def show
  end

  def new
    @discussion = Discussion.new
  end

  def edit
  end

  def create
    @discussion = @event.discussions.new(discussion_params)
    set_speaker
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html {
          flash[:success] = 'Discussion created successfully'
          redirect_to @event
        }
      else
        format.html {
          flash.now[:error] = 'Discussion creation failed'
          render :new
        }
      end
    end
  end

  def update
    set_speaker
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html {
          flash[:success] = 'Discussion edited successfully'
          redirect_to @event
        }
      else
        format.html{
          flash.now[:error] = 'Unable to edit discussion'
          render :edit
        }
      end
    end
  end

  private

    def check_if_discussion_is_upcoming
      if !(@discussion.upcoming?)
        redirect_to event_path(@event), notice: "Past discussions cannot be edited"
      end
    end

    def set_speaker
      @speaker = User.find_by(email: params[:discussion][:speaker])
      @discussion.speaker = @speaker
    end

    def set_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to events_path, alert: 'Couldn\'t find the required event' unless @event
    end

    def set_creator
      @creator = current_user
      redirect_to events_path, alert: 'Couldn\'t find the required Creator' unless @creator
    end

    def set_discussion
      @discussion = @event.discussions.find_by(id: params[:id])
      redirect_to event_discussions_path, alert: 'Couldn\'t find the required discussion' unless @discussion
    end

    def discussion_params
      params.require(:discussion).permit(:creator_id, :id, :name, :topic, :date, :start_time, :end_time, :description, :enabled, :location)
    end

end
