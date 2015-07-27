class DiscussionsController < ApplicationController

  before_action :set_event, only: [:index, :show, :new, :edit, :create, :update]
  before_action :set_creator, only: [:index, :show, :new, :edit, :create, :update]
  before_action :set_discussion, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @discussions = @event.discussions.enabled.order_by_date_time
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
    respond_to do |format|
      if @discussion.save
        format.html { redirect_to Event.find_by_id(@discussion.event_id), notice: 'Discussion created successfully' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html { redirect_to @event, notice: 'Discussion created successfully' }
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

    def set_creator
      @creator = User.find_by(id: params[:user_id])
      redirect_to events_path, alert: 'Couldn\'t find the required User' unless @event
    end

    def set_discussion
      @discussion = @event.discussions.find_by(id: params[:id])
      redirect_to event_discussions_path, alert: 'Couldn\'t find the required discussion' unless @discussion
    end

    def discussion_params
      params.require(:discussion).permit(:creator_id, :discussion_id, :name, :topic, :date, :start_time, :end_time, :description, :enabled, :location)
    end

end
