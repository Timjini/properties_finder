class PropertiesController < ApplicationController
  include ApiResponseHandler
  include ApiExceptionsHandler
  def index
    properties = PropertyService.new(property_search_params).call

    return render_error_response("No properties found matching the criteria", :not_found) if properties.blank?

    render_success_response(data: properties, message: "Properties successfully retrieved.", status: :ok)
  end

  private

  def property_search_params
    params.permit(:lng, :lat, :marketing_type, :property_type, :radius)
  end
end
