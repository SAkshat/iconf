module DiscussionsHelper

  def discussion_duration(discussion)
    discussion.start_time.strftime("%H:%M") + ' - ' +
    discussion.end_time.strftime("%H:%M") + ' , ' +
    discussion.date.strftime("%d %b %Y")
  end

  def user_attending_discussion?(discussion, current_user)
    discussion.attendees.ids.include?(current_user.id)
  end

end
