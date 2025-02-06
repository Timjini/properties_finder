class Property < ApplicationRecord
  # These adjustments were not in the task and might not be used ?
  # require fileds on creation
  validates :zip_code, :city, :lat, :lng, :property_type, :marketing_type, :price, presence: true

  # validate numerical fields 
  validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lng, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :construction_year, numericality: { only_integer: true, greater_than: 1800 }, allow_nil: true
  validates :number_of_rooms, numericality: { greater_than: 0 }, allow_nil: true
  validates :price, numericality: { greater_than: 0 }

  # # validate the type enum
  # validates :property_type, inclusion: { in: %w[apartment single_family_house] }

  # # validate marketing enum
  # validates :marketing_type, inclusion: { in: %w[rent sell] }
 
  #using ll_to_earth 
  scope :within_radius, ->(lat, lng, offer_type, property_type, radius = 5000) {
    select(:id, :street, :house_number, :city, :zip_code, :price, :lat, :lng)
      .where(offer_type: offer_type, property_type: property_type)
      .where(
        "earth_distance(
          ll_to_earth(lat::double precision, lng::double precision),
          ll_to_earth(?::double precision, ?::double precision)
        ) <= ?", lat, lng, radius
      )
  }

  # validate fileds before saving
  before_save :normalize_strings

  private

  def normalize_strings
    self.zip_code = zip_code.strip if zip_code.present?
    self.city = city.strip.titleize if city.present?
    self.street = street.strip.titleize if street.present?
  end
end
