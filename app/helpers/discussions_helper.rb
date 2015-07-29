module DiscussionsHelper

  def discussion_duration(discussion)
    discussion.start_time.strftime("%H:%M") + ' - ' +
    discussion.end_time.strftime("%H:%M") + ' , ' +
    discussion.date.strftime("%d %b %Y")
  end

end
