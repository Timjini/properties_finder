class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActionController::RoutingError, with: :render_not_found_response
  rescue_from StandardError, with: :render_internal_server_error

  private

  # validate models
  def validate_model(model)
    if model.valid?
      true
    else
      render json: {
        status: "error",
        message: "Validation failed",
        errors: model.errors.full_messages
      }, status: :unprocessable_entity
      false
    end
  end

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
  end
end
