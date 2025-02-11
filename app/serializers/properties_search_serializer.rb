class PropertiesSearchSerializer < ActiveModel::Serializer
  attributes :id, :house_number, :street, :city, :zip_code, :state, :lat, :lng, :price

  def state
    object.city
  end
end
