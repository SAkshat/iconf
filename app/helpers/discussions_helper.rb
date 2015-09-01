module DiscussionsHelper

  def discussion_duration(discussion)
    discussion.start_time.to_s(:time) + ' - ' +
    discussion.end_time.to_s(:time) + ' , ' +
    discussion.date.to_s(:date)
  end

  def user_attending_discussion?(discussion, current_user)
    discussion.attendees.ids.include?(current_user.id)
  end

  def discussion_enabled?(discussion)
    discussion.enabled? && discussion.event.enabled? && discussion.creator.enabled?
  end

  def is_discussion_rateable_by?(discussion, user)
    discussion.attendees.include? user
  end

  def get_average_rating_for(discussion)
    ratings = discussion.ratings
    if ratings.empty?
      return 'N/A'
    else
      rating = ratings.pluck(:rating).inject(:+).to_f / ratings.count
      (rating * 10).round / 10.0
    end
  end

end
