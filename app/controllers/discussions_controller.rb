class DiscussionsController < ApplicationController

  include Loader

  before_action :load_event, only: [:index, :show, :new, :edit, :create, :update]
  before_action :load_creator, only: [:new, :edit, :create, :update]
  before_action :load_discussion, only: [:show, :edit, :update]
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
      if @discussion.save
        format.html { redirect_to @event, success: 'Discussion created successfully' }
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
        format.html { redirect_to @event, success: 'Discussion updated successfully' }
      else
        format.html{
          flash.now[:error] = 'Unable to edit discussion'
          render :edit
        }
      end
    end
  end

  private

    # [TODO - S] discussion is past. Incorrect name.
    def check_if_discussion_is_upcoming
      if !(@discussion.upcoming?)
        redirect_to event_path(@event), notice: 'Past discussions cannot be edited'
      end
    end

    def set_speaker
      # [TODO - S] No need to make it instance variable.
      @speaker = User.find_by(email: params[:discussion][:speaker])
      @discussion.speaker = @speaker
    end

    def load_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to events_path, alert: "Couldn't find the required event" unless @event
    end

    def load_discussion
      @discussion = @event.discussions.find_by(id: params[:id])
      redirect_to event_discussions_path, alert: "Couldn't find the required discussion" unless @discussion
    end

    def discussion_params
      # [TODO - S] Why permitting id? Also, is creator_id being set via a hidden field?
      params.require(:discussion).permit(:creator_id, :id, :name, :topic, :date, :start_time, :end_time, :description, :enabled, :location)
    end

end
