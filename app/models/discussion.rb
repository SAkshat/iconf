class Discussion < ActiveRecord::Base
  belongs_to :event
  belongs_to :creator, class_name: :User
  belongs_to :speaker, class_name: :User
  has_many :discussions_users
  has_many :attendees, through: :discussions_users, source: :user

  validates :name, :topic, :location, presence: true
  validates :description, length: { minimum: 50, maximum: 250 }
  validates :speaker, presence: { message: 'does not have a valid email id' }
  # [DONE TODO - S] Please rename.
  validate :is_discussion_between_event_time
  # [DONE TODO - S] Can be implemented using Rails validations.
  # A - Cannot be implemented using numericality or length
  validate :end_time_greater_than_start_time
  # [DONE TODO DOUBT - S] This should not be a validation. Why??
  # Implement using callbacks
  validate :can_discussion_be_enabled, on: [:enable, :disable]

  scope :enabled, -> { where(enabled: true) }

  def is_discussion_between_event_time
    start_time, end_time = event.start_time.to_date, event.end_time.to_date
    unless date >= start_time && date <= end_time
      errors[:date] << "must be within the event duration [#{ start_time } -- #{ end_time }]"
    end
  end

  def can_discussion_be_enabled
    if !(event.enabled? && creator.enabled?)
      errors[:base] << 'cannot be enabled'
    end
  end

  def end_time_greater_than_start_time
    errors[:end_time] << 'should be more than start time' if start_time > end_time
  end

  def upcoming?
    date > Date.current || ( date == Date.current && start_time > Time.current.utc)
  end

end
