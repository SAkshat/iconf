class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :designation
end
