module ApiResponseHandler
  extend ActiveSupport::Concern

  def json_response(success:, message:, data: nil, errors: nil, status: 500)
    render json: JsonResponse.new(success: success, message: message, data: data, errors: errors), status: status
  end

  def render_error_response(error, status = 422, message = "")
    json_response(success: false, message: message, errors: error, status: status)
  end

  def render_success_response(data: {}, message: "", status: 200)
    json_response(success: true, message: message, data: serialize_data(data), status: status)
  end

  def serialize_data(data)
    if data.is_a?(ActiveRecord::Relation)
      data = data.to_a
    end
    if data.is_a?(Array)
      data.map { |item| serialize_item(item) }
    else
      serialize_item(data)
    end
  end

  def serialize_item(item)
    serializer_class = "#{item.class.name}Serializer".constantize
    serializer_class.new(item).serializable_hash[:data][:attributes]
  end
end
