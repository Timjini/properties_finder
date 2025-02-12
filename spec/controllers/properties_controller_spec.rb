# spec/controllers/properties_controller_spec.rb
require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  describe 'GET #index' do
    let(:valid_params) do
      {
        lat: 40.7128,
        lng: -74.0060,
        property_type: 'apartment',
        marketing_type: 'rent'
      }
    end

    let(:property_service) { instance_double(PropertyService) }
    let(:properties) do
      [
        Property.new(
          id: 1,
          lat: 40.7128,
          lng: -74.0060,
          property_type: 'apartment',
          marketing_type: 'rent',
          # add other required attributes here
        ),
        Property.new(
          id: 2,
          lat: 40.7130,
          lng: -74.0065,
          property_type: 'apartment',
          marketing_type: 'rent',
          # add other required attributes here
        )
      ]
    end

    context 'with valid parameters' do
      before do
        allow(PropertyService).to receive(:new).and_return(property_service)
        allow(property_service).to receive(:call).and_return(properties)
      end

      it 'returns success response with properties' do
        get :index, params: valid_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be true
        expect(json_response['message']).to eq('Properties successfully retrieved.')
        expect(json_response['data']).to be_present
      end

      it 'initializes PropertyService with correct parameters' do
        get :index, params: valid_params

        expect(PropertyService).to have_received(:new).with(
          valid_params[:lng].to_f,
          valid_params[:lat].to_f,
          valid_params[:marketing_type],
          valid_params[:property_type]
        )
      end
    end

    context 'when no properties are found' do
      before do
        allow(PropertyService).to receive(:new).and_return(property_service)
        allow(property_service).to receive(:call).and_return([])
      end

      it 'returns not found status' do
        get :index, params: valid_params

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['message']).to eq('No properties found matching the criteria')
      end
    end

    context 'with invalid parameters' do
      context 'when latitude is invalid' do
        let(:invalid_params) { valid_params.merge(lat: 'invalid') }

        it 'returns validation error' do
          get :index, params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)

          expect(json_response['status']).to eq('error')
          expect(json_response['message']).to eq('Validation failed')
          expect(json_response['errors']).to be_an(Array)
          expect(json_response['errors']).to include('Lat is not a number')
        end
      end

      context 'when longitude is invalid' do
        let(:invalid_params) { valid_params.merge(lng: 'invalid') }

        it 'returns validation error' do
          get :index, params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)

          expect(json_response['status']).to eq('error')
          expect(json_response['message']).to eq('Validation failed')
          expect(json_response['errors']).to be_an(Array)
          expect(json_response['errors']).to include('Lng is not a number')
        end
      end

      context 'when required parameters are missing' do
          let(:invalid_params) { { lat: 40.7128 } }

          it 'returns validation error' do
            get :index, params: invalid_params
            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['errors'].any? { |error| error.include?('not included in the list') }).to be true
          end
        end
      end

    context 'when service raises an error' do
      before do
        allow(PropertyService).to receive(:new).and_return(property_service)
        allow(property_service).to receive(:call).and_raise(StandardError, 'Something went wrong')
      end

      it 'handles the error gracefully' do
        get :index, params: valid_params

        expect(response).to have_http_status(:internal_server_error)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end
    end
  end
end
