require 'recruiter/github_repository'
require 'recruiter/redis_cache'
require 'recruiter/cache_mechanism'

module Recruiter
  class CachedGithubRepository
    include CacheMechanism

    def initialize(repository, caching_method)
      @composite = repository
      @caching_method = caching_method
    end

    def cache_namespace
      full_name
    end

    def full_name
      @composite.full_name
    end

    def client
      @composite.client
    end
  end
end
