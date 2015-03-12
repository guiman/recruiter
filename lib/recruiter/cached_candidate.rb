require 'recruiter/candidate'
require 'redis'

module Recruiter
  class CachedCandidate < Candidate
    def self.redis
      @redis ||= ::Redis.new
    end

    def all_repositories
      redis_cache_key = "#{login}_all_repositories"
      if repositories = self.class.redis.get(redis_cache_key)
        cached_candidate = Marshal.load(repositories)
      else
        repositories = super
        self.class.redis.set(redis_cache_key, Marshal.dump(repositories))
        cached_candidate = repositories
      end

      cached_candidate
    end

    def languages
      redis_cache_key = "#{login}_languages"
      if repositories = self.class.redis.get(redis_cache_key)
        cached_candidate = Marshal.load(repositories)
      else
        repositories = super
        self.class.redis.set(redis_cache_key, Marshal.dump(repositories))
        cached_candidate = repositories
      end

      cached_candidate
    end

  end
end
