class Rating < ActiveRecord::Base
  belongs_to :discussions

  RATING_LIST = [1.0, 2.0, 3.0, 4.0, 5.0]

end
