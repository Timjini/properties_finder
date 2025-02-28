class Property < ApplicationRecord
  # require fileds on creation
  # Alias used to match URL params
  alias_attribute :marketing_type, :offer_type

  # validate query fields
  validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lng, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  # # validate the type enum
  validates :property_type, inclusion: { in: %w[mid_terrace_house apartment_maisonette apartment semi_detached_house
                                                villa end_terrace_house penthouse multi_family_house single_family_house apartment_roof_storey] }
  # # validate marketing enum
  validates :offer_type, inclusion: { in: %w[rent sell] }

  scope :within_selected_radius, ->(lat, lng, radius) {
    where(
      "earth_distance(
        ll_to_earth(lat::double precision, lng::double precision),
        ll_to_earth(?::double precision, ?::double precision)
      ) <= ?", lat, lng, radius
    )
  }


  def state
    city
  end
end
