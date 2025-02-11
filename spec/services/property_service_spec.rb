require 'rails_helper'

RSpec.describe PropertyService, type: :service do
  let(:lng) { 13.4236807 }
  let(:lat) { 52.5342963 }
  let(:property_type) { 'apartment' }
  let(:offer_type) { 'sell' }
  let(:radius) { 5000 }
  let(:service) { PropertyService.new(lng, lat, offer_type, property_type, radius) }

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

    it 'returns an empty list when no properties are within the radius' do
      result = service.call
      expect(result).to be_empty
    end

    it 'returns only properties exactly at the given location when radius is 0' do
      radius_zero_service = PropertyService.new(lng, lat, offer_type, property_type, 0)
      
      property = Property.create!(
        offer_type: offer_type,
        property_type: property_type,
        zip_code: '10405',
        city: 'Berlin',
        street: 'Marienburger Str.',
        house_number: '31',
        lng: lng,
        lat: lat,
        price: 100000
      )

      result = radius_zero_service.call
      expect(result).to include(property)
    end

    it 'does not return properties outside the given location when radius is 0' do
      radius_zero_service = PropertyService.new(lng, lat, offer_type, property_type, 0)
      
      property_outside = Property.create!(
        offer_type: offer_type,
        property_type: property_type,
        zip_code: '10405',
        city: 'Berlin',
        street: 'Marienburger Str.',
        house_number: '32',
        lng: lng + 0.0001,
        lat: lat + 0.0001,
        price: 100000
      )

      result = radius_zero_service.call
      expect(result).not_to include(property_outside)
    end
    # Test on large dataset

    it 'returns properties quickly with a large dataset' do
      1000.times do |i|
        Property.create!(
          offer_type: offer_type,
          property_type: property_type,
          zip_code: '10405',
          city: 'Berlin',
          street: "Street #{i}",
          house_number: "#{i}",
          lng: 13.4236807 + i * 0.00001,
          lat: 52.5342963 + i * 0.00001,
          price: 100000
        )
      end

      result = service.call
      expect(result.size).to eq(1000)
    end

    it 'includes properties exactly on the edge of the radius' do
      property_on_edge = Property.create!(
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
      expect(result).to include(property_on_edge)
    end

    it 'handles large radius values and performs as expected' do
      # Set the large radius value
      large_radius = 10000
      large_radius_service = PropertyService.new(lng, lat, offer_type, property_type, large_radius)

      # Create a property just outside the large radius (for testing exclusion)
      property_outside = Property.create!(
        offer_type: offer_type,
        property_type: property_type,
        zip_code: '10405',
        city: 'Berlin',
        street: 'Marienburger Str.',
        house_number: '32',
        lng: lng + 0.1,  # Slightly different longitude (simulating a property outside of the large radius)
        lat: lat + 0.1,  # Slightly different latitude (simulating a property outside of the large radius)
        price: 100000
      )

      # Create a property within the radius for testing inclusion
      property_within = Property.create!(
        offer_type: offer_type,
        property_type: property_type,
        zip_code: '10405',
        city: 'Berlin',
        street: 'Marienburger Str.',
        house_number: '33',
        lng: lng + 0.001,  # Slightly different longitude (still within the large radius)
        lat: lat + 0.001,  # Slightly different latitude (still within the large radius)
        price: 100000
      )

      result = large_radius_service.call

      expect(result).to include(property_within)

      expect(result).not_to include(property_outside)

      expect(result).not_to be_empty
    end

  end
end
