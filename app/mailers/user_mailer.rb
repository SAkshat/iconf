class UserMailer < ApplicationMailer



  def reminder_email(discussion, attendee, referrer)
    @discussion = discussion
    @event = @discussion.event
    @user = attendee
    mail(to: @user.email, subject: @discussion.name + ' Commencement Reminder')
  end

  def discussion_disable_email(user, discussion)
    @user = user
    @discussion = discussion
    @event = @discussion.event
    mail(to: @user.email, subject: @discussion.name + ' Cancellation Notification')
  end

end
