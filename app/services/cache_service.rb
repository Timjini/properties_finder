# class CacheService
#   def self.fetch_cache(key, expires_in: 1.hour, &block)
#     cached_data = Rails.cache.read(key)
#     return cached_data if cached_data.present?

#     data = block.call
#     Rails.cache.write(key, data, expires_in: expires_in)
#     data
#   end
# end
