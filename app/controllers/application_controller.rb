class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActionController::RoutingError, with: :render_not_found_response
  rescue_from StandardError, with: :render_internal_server_error

  private

  def render_not_found_response(exception)
    log_error(exception)
    render json: { status: 404, error: "Not Found", message: exception.message }, status: :not_found
  end

  def render_internal_server_error(exception)
    log_error(exception)
    render json: { status: 500, error: "Internal Server Error", message: "Something went wrong" }, status: :internal_server_error
  end

  def log_error(exception)
    Rails.logger.error "Error: #{exception.class} - #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    Rails.logger.error "Request URL: #{request.original_url}" if request
    Rails.logger.error "Request Params: #{request.params.to_unsafe_h}" if request && request.params.present?
  end

  def route_not_found
    render json: { status: 404, error: "Not Found", message: "The requested route does not exist" }, status: :not_found
  end
end
