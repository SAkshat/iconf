module DiscussionsHelper

  def discussion_duration(discussion)
    discussion.start_time.to_s(:time) + ' - ' +
    discussion.end_time.to_s(:time) + ' , ' +
    discussion.date.to_s(:date)
  end

  def user_attending_discussion?(discussion, current_user)
    discussion.attendees.ids.include?(current_user.id)
  end

end
