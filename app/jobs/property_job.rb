class PropertyJob
  include Sidekiq::Job

  def perform(lng, lat, offer_type, property_type, radius = 5000)
    property_service = PropertyService.new(lng, lat, offer_type, property_type)
    properties = property_service.call

    cache_key = jid
    Rails.logger.info "Storing data in Redis with key: #{cache_key}"

    Redis.current.setex(cache_key, 1.hour, properties.to_json)

    stored_data = Redis.current.get(cache_key)
    Rails.logger.info "Stored data check: #{stored_data ? 'Data exists' : 'Data is missing'}"
  rescue StandardError => e
    Rails.logger.error "PropertyJob error: #{e.message}"
  end
end
