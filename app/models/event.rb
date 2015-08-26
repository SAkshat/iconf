class Event < ActiveRecord::Base

  include PgSearch
  # [DONE TODO - G] See if there exists an option to return all records on empty string. There doesn't exist
  pg_search_scope :search_keyword, against: :name, associated_against: {
    address: [:city, :country],
    discussions: :topic
  }, using: { tsearch: { prefix: true } }

  has_one :contact_detail, as: :contactable, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :discussions, dependent: :destroy
  belongs_to :creator, class_name: :User

  mount_uploader :logo, LogoUploader

  accepts_nested_attributes_for  :address, :contact_detail, :discussions, allow_destroy: true, reject_if: :all_blank

  validates :name, :description, :start_time, :end_time, presence: true
  validates :description, length: { maximum: 500, minimum: 50 }, allow_blank: true
  validates :enabled, inclusion: [true, false]
  validate :start_time_not_be_in_past, on: [:create], if: :start_time?
  validate :end_time_is_after_start_time, if: :start_time? && :end_time?
  validate :is_creator_enabled, on: [:update]

  scope :enabled, -> { where(enabled: true) }
  scope :enabled_with_enabled_creator, -> { where(creator_id: User.enabled.pluck(:id)).enabled }
  scope :forthcoming, -> { where('start_time > ?', Time.now)}

  def upcoming?
    start_time > Time.current
  end

  def start_time_not_be_in_past
    errors[:start_time] << 'cannot be in the past' if start_time.try(:<=, Time.current)
  end

  def end_time_is_after_start_time
    errors[:end_time] << 'must be later than start time' if start_time.try(:>=, end_time)
  end

  def live?
    start_time <= Time.current && end_time >= Time.current
  end

  def is_creator_enabled
    if !creator.enabled?
      errors[:base] << 'Cannot be enabled'
    end
  end

  def is_enabled?
    enabled? && creator.enabled?
  end
end
