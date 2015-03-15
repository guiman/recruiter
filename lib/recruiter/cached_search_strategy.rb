require 'recruiter/github_search_strategy'
require 'redis'

module Recruiter
  class CachedSearchStrategy
    def initialize(composite: ::Recruiter::GithubSearchStrategy.new)
      @composite = composite
    end

    def self.redis
      @redis ||= ::Redis.new
    end

    def all(search)
      redis_cache_key = search

      if cached_search = self.class.redis.get(redis_cache_key)
        cached_search = Marshal.load(cached_search)
      else
        search_results = @composite.all(search)
        self.class.redis.set(redis_cache_key, Marshal.dump(search_results))
        cached_search = search_results
      end

      cached_search
    end
  end
end
