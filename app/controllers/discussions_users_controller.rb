class DiscussionsUsersController < ApplicationController

  def create
    if current_user.discussions_users.create(discussion_id: params[:id])
      redirect_to :back, notice: "You have successfully RSVP'd to this discussion"
    else
      redirect_to :back, flash: { error: "Couldn't RSVP to the discussion" }
    end
  end

  def destroy
    if current_user.discussions_users.find_by(discussion_id: params[:id]).destroy
      redirect_to :back, notice: 'You opted out of this discussion'
    else
      redirect_to :back, flash: { error: "Couldn't opt out of the discussion" }
    end
  end

end
