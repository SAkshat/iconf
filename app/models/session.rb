class Session < ActiveRecord::Base
  belongs_to :event
  # has_one :speaker, as :user
end
