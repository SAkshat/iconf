class UserMailer < ApplicationMailer

  def reminder_email(user, discussion)
    @user = user
    @discussion = discussion
    @event = @discussion.event
    mail(to: @user.email, subject: 'Reminder')
  end

  def discussion_disable_email(user, discussion)
    @user = user
    @discussion = discussion
    @event = @discussion.event
    mail(to: @user.email, subject: 'Cancellation Notification')
  end

end
