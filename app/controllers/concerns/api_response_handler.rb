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
    if item.is_a?(String)
      return fetch_from_redis_with_retry(item)
    end

    return item if item.is_a?(Hash)

    serializer_class = "#{item.class.name}Serializer".constantize
    serializer_class.new(item).serializable_hash[:data][:attributes]
  end


  def fetch_from_redis_with_retry(key, retries: 10, delay: 0.2)
    attempt = 0

    while attempt < retries
      cached_data = Redis.current.get(key)
      return JSON.parse(cached_data, symbolize_names: true) if cached_data

      Rails.logger.info "Retry #{attempt + 1}: No data found in Redis for key #{key}, waiting..."
      sleep(delay * (2**attempt))
      attempt += 1
    end

    Rails.logger.error "Failed to fetch data from Redis after #{retries} attempts"
    {}
  end
end
