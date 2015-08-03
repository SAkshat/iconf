class ContactDetail < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  validates :email, :phone_number, presence: true
  validates :email, format: { with: Devise.email_regexp }, allow_blank: true
  validates :phone_number, numericality: { only_integer: true }, allow_blank: true
end
