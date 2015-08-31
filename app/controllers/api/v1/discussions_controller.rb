class API::V1::DiscussionsController < API::V1::ApplicationController

  before_action :load_discussion, only: [:attendees]

  def attendees
    render json: @discussion.attendees
  end


  private

    def load_discussion
      @discussion = Discussion.find_by(id: params[:discussion_id])
      render json: { error: "Discussion doesn't exist", status: 404 } if !@discussion
    end

end
