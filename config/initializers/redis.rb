class Redis
  def self.current
    @current ||= begin
      client = Redis.new(url: ENV.fetch("REDIS_URL", "redis://redis:6379/0"))
      client
    rescue StandardError => e
      Rails.logger.error("Failed to connect to Redis: #{e.message}")
      nil
    end
  end
end
