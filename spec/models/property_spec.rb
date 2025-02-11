require 'rails_helper'

RSpec.describe Property, type: :model do
  describe "scopes" do
    let!(:property1) do
      Property.create(
        lat: 52.5342963, lng: 13.4236807, property_type: "apartment", offer_type: "sell",
        price: 100000, zip_code: "12345", city: "Berlin", street: "Main St", house_number: "1"
      )
    end

    let!(:property2) do
      Property.create(
        lat: 52.5343963, lng: 13.4237807, property_type: "apartment", offer_type: "sell",
        price: 120000, zip_code: "12345", city: "Berlin", street: "Main St", house_number: "2"
      )
    end

    let!(:property3) do
      # outside the radius
      Property.create(
        lat: 52.9343963, lng: 13.9237807, property_type: "apartment", offer_type: "sell",
        price: 80000, zip_code: "12345", city: "Berlin", street: "Main St", house_number: "3"
      )
    end

    it "returns properties within the selected radius" do
      properties = Property.within_selected_radius(52.5342963, 13.4236807, 5000)
      puts "-------> result: #{properties.first.inspect}"
      expect(properties).to include(property1)
      expect(properties).to include(property2)
      expect(properties).not_to include(property3)
    end

    it "returns properties within the default radius" do
      properties = Property.within_selected_radius(52.5342963, 13.4236807, 5000)
      puts "-------> result: #{properties.length}"
      expect(properties).to include(property1)
      expect(properties).to include(property2)
    end
  end
end
