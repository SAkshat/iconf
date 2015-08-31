class DiscussionsUsersController < ApplicationController

  def create
    discussion = Discussion.find_by(id: params[:id])
    if discussion && current_user.discussions_users.create(discussion_id: discussion.id)
      queue_user_for_discussion_reminder(discussion, current_user)
      redirect_to :back, notice: "You have successfully RSVP'd to this discussion"
    else
      redirect_to :back, flash: { error: "Couldn't RSVP to the discussion" }
    end
  end

  def destroy
    discussion_user = current_user.discussions_users.find_by(discussion_id: params[:id])
    remove_reminder_email_from_queue(discussion_user)
    if discussion_user && discussion_user.destroy
      redirect_to :back, notice: 'You opted out of this discussion'
    else
      redirect_to :back, flash: { error: "Couldn't opt out of the discussion" }
    end
  end

  private

    def remove_reminder_email_from_queue(discussion_user)
    end

    def queue_user_for_discussion_reminder(discussion, attendee)
      discussion_user = DiscussionsUser.where(discussion: discussion, user: attendee)
      UserMailer.delay(run_at: reminder_time(discussion)).reminder_email(discussion, attendee, discussion_user)
    end

    def reminder_time(discussion)
      discussion.date.to_datetime + discussion.start_time.seconds_since_midnight.seconds
    end

end
