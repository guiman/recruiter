require 'recruiter/search'
require 'redis'
require 'json'

module Recruiter
  class CachedSearch < Search
    def self.redis
      @redis ||= ::Redis.new
    end

    def all
      redis_cache_key = filters

      if cached_search = self.class.redis.get(redis_cache_key)
        cached_search = Marshal.load(cached_search)
      else
        search_results = super
        self.class.redis.set(redis_cache_key, Marshal.dump(search_results))
        self.class.redis.expire redis_cache_key, 300
        cached_search = search_results
      end

      cached_search
    end
  end
end
