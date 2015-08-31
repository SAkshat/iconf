class DiscussionsUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :discussion

  after_create :queue_user_for_discussion_reminder
  before_destroy :remove_reminder_email_from_queue

  def queue_user_for_discussion_reminder
    delayed_job = UserMailer.delay(run_at: reminder_time(discussion)).reminder_email(discussion, user)
    DiscussionsUser.where(user: user, discussion: discussion).first.update(delayed_job_id: delayed_job.id)
  end

  def remove_reminder_email_from_queue
    delayed_job = Delayed::Job.find_by(id: delayed_job_id)
    if delayed_job
      delayed_job.delete
    end
  end

  def reminder_time(discussion)
    discussion.date.to_datetime + discussion.start_time.seconds_since_midnight.seconds
  end

end
