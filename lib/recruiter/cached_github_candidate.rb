require 'recruiter/github_candidate'
require 'redis'

module Recruiter
  class CachedGithubCandidate
    def initialize(candidate)
      @candidate = candidate
    end

    def self.redis
      @redis ||= ::Redis.new
    end

    def method_missing(name)
      @candidate.public_send(name)
    end

    def all_repositories
      redis_cache_key = "#{@candidate.login}_all_repositories"
      if repositories = self.class.redis.get(redis_cache_key)
        cached_repositories = Marshal.load(repositories)
      else
        repositories = @candidate.all_repositories
        self.class.redis.set(redis_cache_key, Marshal.dump(repositories))
        cached_repositories = repositories
      end

      cached_repositories
    end

    def languages
      redis_cache_key = "#{@candidate.login}_languages"
      if languages = self.class.redis.get(redis_cache_key)
        cached_languages = Marshal.load(languages)
      else
        languages = @candidate.languages
        self.class.redis.set(redis_cache_key, Marshal.dump(languages))
        cached_languages = languages
      end

      cached_languages
    end

    def email
      redis_cache_key = "#{@candidate.login}_email"
      if email = self.class.redis.get(redis_cache_key)
        cached_email = Marshal.load(email)
      else
        email  = @candidate.email
        self.class.redis.set(redis_cache_key, Marshal.dump(email))
        cached_email = email
      end

      cached_email
    end
  end
end
