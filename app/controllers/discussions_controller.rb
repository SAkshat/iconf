class DiscussionsController < ApplicationController

  before_action :load_event, only: [:index, :show, :new, :edit, :create, :update]
  before_action :load_discussion, only: [:show, :edit, :update]
  before_action :is_session_editable, only: [:update]
  before_action :check_if_discussion_is_past, only: [:edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @discussions = @event.discussions.includes(:ratings).enabled.order(:date, :start_time)
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

    def check_if_discussion_is_past
      if !(@discussion.upcoming?)
        redirect_to event_path(@event), notice: 'Past discussions cannot be edited'
      end
    end

    def set_speaker
      @discussion.speaker = User.find_by(email: params[:discussion][:speaker])
    end

    def load_event
      @event = Event.find_by(id: params[:event_id])
      redirect_to events_path, alert: "Couldn't find the required event" unless @event
    end

    def load_discussion
      @discussion = @event.discussions.includes(:ratings).find_by(id: params[:id])
      redirect_to event_discussions_path, alert: "Couldn't find the required discussion" unless @discussion
    end

    def discussion_params
      params.require(:discussion).permit(:creator_id, :name, :topic, :date, :start_time, :end_time, :description, :enabled, :location)
    end

    def is_session_editable
      errors[:base] << 'Discussion is in the past' unless @discussion.upcoming?
    end

end
