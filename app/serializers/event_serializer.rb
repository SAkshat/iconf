class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_time, :description, :logo
  has_many :discussions
  has_one :contact_detail, :address
end
