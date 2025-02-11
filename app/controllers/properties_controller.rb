class PropertiesController < ApplicationController
  include ApiResponseHandler
  include ApiExceptionsHandler

  def index
    property = Property.new(property_params)
    return unless validate_model(property)

    properties = PropertyService.new(
      params[:lng].to_f,
      params[:lat].to_f,
      params[:marketing_type],
      params[:property_type]
    ).call

    return render_error_response("No properties found matching the criteria", :not_found) if properties.blank?

    render_success_response(data: properties, message: "Properties successfully retrieved.", status: :ok)
  end


  private

  def property_params
    params.permit(:lng, :lat, :property_type, :marketing_type)
  end
end
