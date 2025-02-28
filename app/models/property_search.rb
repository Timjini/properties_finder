class PropertySearch
  include ActiveModel::Model

  attr_accessor :lng, :lat, :marketing_type, :property_type, :radius

  DEFAULT_RADIUS = 5000

  validates :lng, :lat, :marketing_type, :property_type, presence: true
  validates :lng, :lat, numericality: true
  validates :radius, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def initialize(params = {})
    super(params)
    @radius ||= DEFAULT_RADIUS
  end

  def to_h
    {
      lng: lng.to_f,
      lat: lat.to_f,
      offer_type: marketing_type.to_s,
      property_type: property_type.to_s,
      radius: radius.to_i
    }
  end
end
