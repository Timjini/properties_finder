class PropertySearchService
  def initialize(lng, lat, offer_type, property_type, radius = 5000)
    @lng = lng.to_f
    @lat = lat.to_f
    @offer_type = offer_type.to_s
    @property_type = property_type.to_s
    @radius = radius.to_i
  end

  def call
    Property
      .within_selected_radius(@lat, @lng, @offer_type, @property_type, @radius)
      .select(:street, :house_number, :city, :zip_code, :price)
  end
end
