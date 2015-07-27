class Discussion < ActiveRecord::Base
  belongs_to :event
  belongs_to :creator, class_name: 'user', foreign_key: 'creator_id'

  validates :name, :topic, :location, presence: true
  validates :description, length: { minimum: 50, maximum: 250 }
  validate :date_during_event_duration
  validate :end_time_greater_than_start_time
  validate :session_is_upcoming

  scope :enabled, -> { where(enabled: true) }
  scope :order_by_date_time, -> { order(:date, :start_time) }


  def date_during_event_duration
    unless date >= event.start_date.to_date && date <= event.end_date.to_date
      errors[:date] << "must be within the event date [#{ event.start_date.to_date } -- #{ event.end_date.to_date }]"
    end
  end

  def end_time_greater_than_start_time
    errors[:end_time] << "should be more than start time" if start_time > end_time
  end


  def session_is_upcoming
    errors[:base] << "Session is in the past" unless upcoming?
  end

  def upcoming?
    start_time > Time.current.utc
  end

end
