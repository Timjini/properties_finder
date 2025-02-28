module Caching
  module Cacheable
    def fetch_from_cache(cache_key, expires_in: 1.hour)
      cache_data = Redis.current.get(cache_key)
      return JSON.parse(cache_data, symbolize_names: true) if cache_data

      result = yield
      Redis.current.setex(cache_key, expires_in, result.to_json)
      result
    end
  end
end
