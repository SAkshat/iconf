class Address < ActiveRecord::Base
  belongs_to :event, dependent: :destroy

  validates :street, :city, :zipcode, :country, presence: true
end
