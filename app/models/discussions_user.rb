class DiscussionsUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :discussion

  after_create :queue_user_for_discussion_reminder
  after_destroy :remove_user_from_discussion_reminder_queue

  private

    def queue_user_for_discussion_reminder
      delayed_job = UserMailer.delay(run_at: reminder_time).reminder_email(discussion, user)
      DiscussionsUser.where(user: user, discussion: discussion).first.update(delayed_job_id: delayed_job.id)
    end

    def remove_user_from_discussion_reminder_queue
      delayed_job = Delayed::Job.find_by(id: delayed_job_id).try(:delete)
    end

    def reminder_time
      discussion.date.to_datetime + discussion.start_time.seconds_since_midnight.seconds
    end

end
