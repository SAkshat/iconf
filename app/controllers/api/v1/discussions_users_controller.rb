class API::V1::DiscussionsUsersController < API::V1::ApplicationController

  before_action :load_discussion, only: [:create, :destroy]
  before_action :load_user, only: [:create, :destroy]

  def create
    if @user.discussions_users.create(discussion_id: @discussion.id)
      render json: { success: "You have successfully RSVP'd to this discussion", status: 200 }
    else
      render json: { failure: "Couldn't RSVP to the discussion", status: 500 }
    end
  end

  def destroy
    if @user.discussions_users.find_by(discussion_id: @discussion.id).destroy
      render json: { success: 'You opted out of this discussion', status: 200 }
    else
      render json: { failure: "Couldn't opt out of the discussion", status: 500 }
    end
  end

  private

    def load_discussion
      @discussion = Discussion.find_by(id: params[:discussion_id])
      render json: { error: 'Discussion not found', status: 404 } if !@discussion
    end

end
