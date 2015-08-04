class Event < ActiveRecord::Base
  has_one :contact_detail, as: :contactable, dependent: :destroy
  has_one :address, dependent: :destroy
  mount_uploader :logo, LogoUploader
  has_many :discussions, dependent: :destroy
  belongs_to :creator, class_name: :User

  accepts_nested_attributes_for :address, :contact_detail

  validates :name, presence: true
  validates :description, length: { maximum: 500, minimum: 50 }
  validate :start_time_cannot_be_in_past
  validate :start_time_before_end_time

  scope :enabled, -> { where(enabled: true) }
  scope :order_by_start_date_time, -> { order(:date, :start_time) }
  scope :order_by_start_date, -> { order(:start_time) }
  #To Do: start_time and end_time are datetime fields. Their name should be start_time and end_time.
  def upcoming?
    start_time > Time.current
  end

  def start_time_cannot_be_in_past
    errors[:start_time] << "cannot be in the past" if start_time <= Time.current
  end

  def start_time_before_end_time
    errors[:end_time] << "must be later than start date" if start_time >= end_time
  end

  def live?
    start_time <= Time.current && end_time >= Time.current
  end

end
