module Caching
  module CacheKeyGenerator
    def generate_cache_key(*key_parts)
      Digest::SHA256.hexdigest(key_parts.join("/"))
    end
  end
end
