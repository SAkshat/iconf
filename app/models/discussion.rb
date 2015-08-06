class Discussion < ActiveRecord::Base
  belongs_to :event
  belongs_to :creator, class_name: :User
  belongs_to :speaker, class_name: :User
  has_many :discussions_users
  has_many :attendees, through: :discussions_users, source: :user

  validates :name, :topic, :location, presence: true
  validates :description, length: { minimum: 50, maximum: 250 }
  validates :speaker, presence: { message: 'does not have a valid email id' }
  validate :time_during_event_duration
  validate :end_time_greater_than_start_time
  validate :is_session_editable, if: :persisted?

  scope :enabled, -> { where(enabled: true) }
  scope :order_by_start_date_time, -> { order(:date, :start_time) }

  def time_during_event_duration
    unless date >= event.start_time.to_date && date <= event.end_time.to_date
      errors[:date] << "must be within the event duration [#{ event.start_time.to_date } -- #{ event.end_time.to_date }]"
    end
  end

  def end_time_greater_than_start_time
    errors[:end_time] << 'should be more than start time' if start_time >= end_time
  end

  def is_session_editable
    errors[:base] << 'Discussion is in the past' unless upcoming?
  end

  def upcoming?
    date > Date.current || ( date == Date.current && start_time > Time.current.utc)
  end

end
