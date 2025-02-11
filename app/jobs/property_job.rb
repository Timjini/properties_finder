class PropertyJob
  include Sidekiq::Job

  def perform(lng, lat, offer_type, property_type, radius = 5000)
    properties = PropertyService.new(lng, lat, offer_type, property_type, radius).call

    if properties.present?
      Rails.logger.info "Found #{properties.count} properties."
    else
      Rails.logger.warn "No properties found matching the criteria."
    end

    properties
  rescue StandardError => e
    Rails.logger.error "PropertyJob error: #{e.message}"
  end
end
