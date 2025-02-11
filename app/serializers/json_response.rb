class JsonResponse
  attr_reader :success, :message, :data, :errors

  def initialize(success:, message:, data: nil, errors: nil)
    @success = success
    @message = message
    @data = data
    @errors = errors
  end

  def as_json(*)
    {
      success: @success,
      message: @message,
      data: @data,
      errors: @errors
    }
  end
end
