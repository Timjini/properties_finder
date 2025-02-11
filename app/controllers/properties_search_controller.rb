class PropertiesSearchController < ApplicationController
  def index
    properties = PropertySearchService.new(
      params[:lng].to_f,
      params[:lat].to_f,
      params[:marketing_type],
      params[:property_type]
    ).call

      render json: {
        status: "success",
        message: "Properties successfully retrieved.",
        properties: ActiveModelSerializers::SerializableResource.new(properties, each_serializer: PropertiesSearchSerializer)
      }, status: :ok
  end

  private

  def property_params
    params.require(:property).permit(:offer_type, :property_type, :zip_code, :city, :street, :house_number,
                                     :lng, :lat, :construction_year, :number_of_rooms, :currency, :price)
  end
end
