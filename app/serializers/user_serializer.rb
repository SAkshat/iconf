class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :title
end
