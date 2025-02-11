class PropertyService
  def initialize(lng, lat, offer_type, property_type, radius = 5000)
    @lng = lng.to_f
    @lat = lat.to_f
    @offer_type = offer_type.to_s
    @property_type = property_type.to_s
    @radius = radius.to_i
  end

  def call
    begin
    Property
      .select(:id, :street, :house_number, :city, :zip_code, :price, :lat, :lng, :offer_type, :property_type)
      .where(offer_type: @offer_type, property_type: @property_type)
      .within_selected_radius(@lat, @lng, @radius)
    rescue StandardError => e
      Rails.logger.error "Unexpected error: #{e.message}"
      raise StandardError, "An unexpected error occurred while retrieving properties"
    end
  end
end
