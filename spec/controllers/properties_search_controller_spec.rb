require 'rails_helper'

RSpec.describe PropertiesSearchController, type: :controller do
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

      it "returns a successful response" do
        get :index, params: valid_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["message"]).to eq("Properties successfully retrieved.")
      end
    end
  end
end
