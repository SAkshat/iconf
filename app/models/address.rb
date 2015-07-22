class Address < ActiveRecord::Base
  belongs_to :event

  validates :street, :city, :zipcode, :country, presence: true
end
