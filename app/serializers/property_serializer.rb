class PropertySerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :house_number, :street, :city, :zip_code, :state, :lat, :lng, :price
end
