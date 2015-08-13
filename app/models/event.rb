class Event < ActiveRecord::Base

  include PgSearch
  # [DONE TODO - G] See if there exists an option to return all records on empty string. There doesn't exist
  pg_search_scope :search_keyword, against: :name, associated_against: {
    address: [:city, :country],
    discussions: :topic
  }, using: { tsearch: { prefix: true } }

  # [TODO - S] Please seggregate into sections. Like all associations together, all validations together.
  # # [TODO - S] Try to follow this convention everywhere. Leads to cleaner and more readable code.
  has_one :contact_detail, as: :contactable, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :discussions, dependent: :destroy
  belongs_to :creator, class_name: :User
  mount_uploader :logo, LogoUploader

  accepts_nested_attributes_for :address, :contact_detail

  validates :name, presence: true
  validates :description, length: { maximum: 500, minimum: 50 }
  validate :start_time_cannot_be_in_past
  # [TODO - S] It can be implemented by using rails validation method.
  validate :start_time_before_end_time
  validate :is_creator_enabled
  # [TODO - S] What does it do? Why specify creator_id??
  scope :enabled, -> { where(enabled: true, creator_id: User.enabled.pluck(:id)) }

  def upcoming?
    start_time > Time.current
  end

  def start_time_cannot_be_in_past
    errors[:start_time] << 'cannot be in the past' if start_time <= Time.current
  end

  # [TODO - S] Method name is different than its function.
  def start_time_before_end_time
    errors[:end_time] << 'must be later than start time' if start_time >= end_time
  end

  def live?
    start_time <= Time.current && end_time >= Time.current
  end

  def is_creator_enabled
    if !creator.enabled?
      errors[:base] << 'Cannot be enabled'
    end
  end


end
