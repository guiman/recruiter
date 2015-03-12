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
        cached_repositories = Marshal.load(repositories)
      else
        repositories = super
        self.class.redis.set(redis_cache_key, Marshal.dump(repositories))
        cached_repositories = repositories
      end

      cached_repositories
    end

    def languages
      redis_cache_key = "#{login}_languages"
      if languages = self.class.redis.get(redis_cache_key)
        cached_languages = Marshal.load(languages)
      else
        languages = super
        self.class.redis.set(redis_cache_key, Marshal.dump(languages))
        cached_languages = languages
      end

      cached_languages
    end

    def email
      redis_cache_key = "#{login}_email"
      if email = self.class.redis.get(redis_cache_key)
        cached_email = Marshal.load(email)
      else
        email  = super
        self.class.redis.set(redis_cache_key, Marshal.dump(email))
        cached_email = email
      end

      cached_email
    end
  end
end
