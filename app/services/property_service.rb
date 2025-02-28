class PropertyService
  include Caching::Cacheable
  include Caching::CacheKeyGenerator

  def initialize(params)
    @search = PropertySearch.new(params)
  end

  def call
    return [] unless @search.valid?

    fetch_from_cache(generate_cache_key(@search.marketing_type, @search.property_type, @search.lat, @search.lng, @search.radius)) { fetch_properties_from_db.as_json }
  end

  private

  def fetch_properties_from_db
    Property.where(offer_type: @search.marketing_type, property_type: @search.property_type)
            .within_selected_radius(@search.lat, @search.lng, @search.radius)
  end
end
