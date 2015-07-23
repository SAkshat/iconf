class Session < ActiveRecord::Base
  belongs_to :event

  validates :name, :topic, :location, presence: true
  validates :description, length: { minimum: 50, maximum: 250 }
  validate :date_during_event_duration
  validate :end_time_greater_than_start_time

  private

    def date_during_event_duration
      unless date > event.start_date.to_date && date < event.end_date.to_date
        errors[:date] << "must be with event date"
      end
    end

    def end_time_greater_than_start_time
      errors[:end_time] << "should be more than start time" if start_time > end_time
    end
end
