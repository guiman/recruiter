require 'recruiter/github_repository'
require 'redis'

module Recruiter
  class CachedGithubRepository
    def initialize(repository)
      @repository = repository
    end

    def self.redis
      @redis ||= ::Redis.new
    end

    def method_missing(name)
      redis_cache_key = "#{@repository.full_name}_#{name}"
      if elements = self.class.redis.get(redis_cache_key)
        cached_elements = Marshal.load(elements)
      else
        elements = @repository.public_send(name)
        self.class.redis.set(redis_cache_key, Marshal.dump(elements))
        cached_elements = elements
      end

      cached_elements
    end

    def client
      @repository.client
    end
  end
end
