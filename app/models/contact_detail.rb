class ContactDetail < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  validates :email, :phone_number, presence: true
  validates :email, format: { with: EMAIL_REGEXP }, allow_blank: true
  # [DONE TODO - S] phone_number is a string field
  validates :phone_number, format: { with: /\A[0-9]{10}\z/ }, allow_blank: true
end
