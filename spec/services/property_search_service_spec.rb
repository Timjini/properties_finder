require 'rails_helper'

RSpec.describe PropertySearchService, type: :service do
  let(:lng) { 13.4236807 }
  let(:lat) { 52.5342963 }
  let(:property_type) { 'apartment' }
  let(:offer_type) { 'sell' }
  let(:radius) { 5000 }
  let(:service) { PropertySearchService.new(lng, lat, offer_type, property_type, radius) }

  describe '#call' do
    it 'returns a list of properties within the radius' do
      property = Property.create!(
        offer_type: offer_type,
        property_type: property_type,
        zip_code: '10405',
        city: 'Berlin',
        street: 'Marienburger Str.',
        house_number: '31',
        lng: 13.4236807,
        lat: 52.5342963,
        price: 100000
      )

      result = service.call
      expect(result).to include(property)
    end
  end
end
