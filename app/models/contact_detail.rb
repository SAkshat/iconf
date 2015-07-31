class ContactDetail < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true, dependent: :destroy
  validates :email, :phone_number, presence: true
  validates :email, format: { with: EMAIL_REGEX }, allow_blank: true
  validates :phone_number, numericality: { only_integer: true }, allow_blank: true
end
