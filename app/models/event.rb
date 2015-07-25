class Event < ActiveRecord::Base
  has_one :contact_detail, as: :contactable, dependent: :destroy
  has_one :address, dependent: :destroy
  mount_uploader :logo, LogoUploader
  has_many :sessions, dependent: :destroy

  accepts_nested_attributes_for :address, :contact_detail

  validates :name, presence: true
  validates :description, length: { maximum: 500, minimum: 50 }
  validate :start_date_cannot_be_in_past
  validate :start_date_before_end_date

  def start_date_cannot_be_in_past
    errors[:start_date] << "cannot be in the past" if start_date < Time.current
  end

  def start_date_before_end_date
    errors[:end_date] << "must be later than start date" if start_date > end_date
  end

  def live?
    start_date <= Time.current && end_date >= Time.current
  end

  def upcoming?
    start_date > Time.current
  end

end
