class ContactDetail < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  validates :email, :phone_number, presence: true
  validates :email, format: { with: EMAIL_REGEXP }, allow_blank: true
  # [TODO - S] phone_number is a string field
  validates :phone_number, numericality: { only_integer: true }, allow_blank: true
end
