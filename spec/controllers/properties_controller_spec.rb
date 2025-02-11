require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  describe "GET #index" do
    context "when parameters are valid" do
      let(:valid_params) do
        {
          lng: 13.4236807,
          lat: 52.5342963,
          property_type: "apartment",
          marketing_type: "sell"
        }
      end

      it "returns a successful response when properties are found" do
        properties = [ double('Property', id: 1, name: "Property 1") ]
        byebug
        allow(PropertyService).to receive(:new).and_return(double(call: properties))

        get :index, params: valid_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["message"]).to eq("Properties successfully retrieved.")
        expect(json_response["data"]).to be_an(Array)
        expect(json_response["data"].first["id"]).to eq(1)
      end
    end

    context "when no properties match the criteria" do
      let(:valid_params) do
        {
          lng: 13.4236807,
          lat: 52.5342963,
          property_type: "apartment",
          marketing_type: "sell"
        }
      end

      it "returns a not found response when no properties are found" do
        # Mocking PropertyService to return an empty array (no properties found)
        allow(PropertyService).to receive(:new).and_return(double(call: []))

        get :index, params: valid_params

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("No properties found matching the criteria")
      end
    end

    context "when an unexpected error occurs" do
      let(:valid_params) do
        {
          lng: 13.4236807,
          lat: 52.5342963,
          property_type: "apartment",
          marketing_type: "sell"
        }
      end

      it "returns an error response when the PropertyService raises an exception" do
        # Simulating an error in PropertyService (e.g., a database error)
        allow(PropertyService).to receive(:new).and_return(double(call: raise(StandardError, "Database error")))

        get :index, params: valid_params

        expect(response).to have_http_status(:internal_server_error)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("An unexpected error occurred while retrieving properties")
      end
    end
  end
end
