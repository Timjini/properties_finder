class PropertyService
  def initialize(lng, lat, offer_type, property_type, radius = 5000)
    @lng = lng.to_f
    @lat = lat.to_f
    @offer_type = offer_type.to_s
    @property_type = property_type.to_s
    @radius = radius.to_i
  end

  # caching for scaling
  def call
    cache_key = generate_cache_key
    cache_data = Redis.current.get(cache_key)

    if cache_data
      Marshal.load(cache_data)
    else
      properties = fetch_properties_from_db
      Redis.current.setex(cache_key, 1.hour, Marshal.dump(properties))
      properties
    end
  end

  private

  def generate_cache_key
    Digest::SHA256.hexdigest("#{offer_type}/#{property_type}/#{lat}/#{lng}/#{radius}")
  end

  def fetch_properties_from_db
    Property.where(offer_type: @offer_type, property_type: @property_type)
            .within_selected_radius(@lat, @lng, @radius)
  end
end
