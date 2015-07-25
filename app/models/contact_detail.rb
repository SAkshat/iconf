class ContactDetail < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true, dependent: :destroy
  validates :email, :phone_number, presence: true
  validates :email, format: { with: /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i }
  validates :phone_number, numericality: { only_integer: true }
end
