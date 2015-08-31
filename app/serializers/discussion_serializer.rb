class DiscussionSerializer < ActiveModel::Serializer
  attributes :id, :name, :topic, :date, :start_time, :end_time, :location, :description
  has_one :speaker
end
