class Rating < ActiveRecord::Base
  belons_to :rateable, polymorphic: true

  RATING_LIST = [1.0, 2.0, 3.0, 4.0, 5.0]

end
