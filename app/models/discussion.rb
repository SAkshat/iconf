class Discussion < ActiveRecord::Base
  belongs_to :event, inverse_of: :discussions
  belongs_to :creator, class_name: :User
  belongs_to :speaker, class_name: :User
  has_many :discussions_users, dependent: :destroy
  has_many :attendees, through: :discussions_users, source: :user

  validates :name, :topic, :location, presence: true
  validates :enabled, inclusion: [true, false]
  validates :description, length: { minimum: 50, maximum: 250 }
  validates :speaker, presence: { message: 'does not have a valid email id' }
  #SPEC CONDITIONAL VALIDATION
  validate :start_time_not_be_in_past, if: :start_time_changed?
  validate :is_discussion_between_event_time
  validate :end_time_greater_than_start_time

  scope :enabled, -> { where(enabled: true) }

  after_save :send_disable_notification_email_to_attendees, if: :discussion_was_disabled?

  def upcoming?
    date > Date.current || ( date == Date.current && start_time > Time.current.utc)
  end

  private

    def is_discussion_between_event_time
      start_time, end_time = event.start_time.to_date, event.end_time.to_date
      unless date >= start_time && date <= end_time
        errors[:date] << "must be within the event duration [#{ start_time } -- #{ end_time }]"
      end
    end

    def end_time_greater_than_start_time
      errors[:end_time] << 'should be more than start time' if start_time >= end_time
    end

    def start_time_not_be_in_past
      errors[:start_time] << 'cannot be in the past' if start_time.try(:<=, Time.current)
    end

    def discussion_was_disabled?
      !enabled && enabled != enabled_was
    end

    def send_disable_notification_email_to_attendees
      attendees.each do |attendee|
        if attendee.email?
          UserMailer.discussion_disable_email(attendee, self).deliver_now
        end
      end
    end

end
