require 'recruiter/github_organization'
require 'redis'

module Recruiter
  class CachedGithubOrganization
    def initialize(candidate)
      @candidate = candidate
    end

    def self.redis
      @redis ||= ::Redis.new
    end

    def method_missing(name)
      redis_cache_key = "#{@candidate.login}_#{name}"
      if elements = self.class.redis.get(redis_cache_key)
        cached_elements = Marshal.load(elements)
      else
        elements = @candidate.public_send(name)
        self.class.redis.set(redis_cache_key, Marshal.dump(elements))
        cached_elements = elements
      end

      cached_elements
    end

    def client
      @candidate.client
    end

    def skills
      ::Recruiter::GithubCandidate::Skills.new(self)
    end

    def activity
      ::Recruiter::GithubCandidate::Activity.new(self)
    end
  end
end
