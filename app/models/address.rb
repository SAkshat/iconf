class Address < ActiveRecord::Base
  belongs_to :event

  #SPEC FORMAT, CONDITIONAL VALIDATION
  validates :street, :city, :zipcode, :country, presence: true
  validates :street, :city, :country, format: { with: /\A[a-z][a-z0-9]*/i }, allow_blank: true
  validates :zipcode, length: { is: 6 }, allow_blank: :true

end
