class PropertySearchService
  def initialize(lng, lat, offer_type, property_type, radius = 5000)
    @lng = lng
    @lat = lat
    @offer_type = offer_type
    @property_type = property_type
    @radius = radius
  end

  def call
    Property
      .within_radius(@lat, @lng, @offer_type, @property_type, @radius)
      .select(:street, :house_number, :city, :zip_code, :price)
  end
end
