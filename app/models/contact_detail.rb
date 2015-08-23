class ContactDetail < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  validates :email, :phone_number, presence: true
  validates :phone_number, format: { with: /\A[0-9]{10}\z/ }, allow_blank: true

  validate :email_format
end
