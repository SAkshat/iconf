class DiscussionsUsersController < ApplicationController

  def create
    # [DONE TODO - S] Should check if the discussion with this id exist.
    discussion = Discussion.find_by(id: params[:id])
    if discussion && current_user.discussions_users.create(discussion_id: discussion.id)
      redirect_to :back, notice: "You have successfully RSVP'd to this discussion"
    else
      redirect_to :back, flash: { error: "Couldn't RSVP to the discussion" }
    end
  end

  def destroy
    # [DONE TODO - S] nil.destroy will raise exception.
    discussion_user = current_user.discussions_users.find_by(discussion_id: params[:id])
    if discussion_user && discussion_user.destroy
      redirect_to :back, notice: 'You opted out of this discussion'
    else
      redirect_to :back, flash: { error: "Couldn't opt out of the discussion" }
    end
  end

end
