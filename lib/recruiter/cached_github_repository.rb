require 'recruiter/github_repository'
require 'recruiter/redis_cache'

module Recruiter
  class CachedGithubRepository
    def initialize(repository, caching_method)
      @composite = repository
      @caching_method = caching_method
    end

    def method_missing(name, *args)
      cache_key = name.to_s
      cache_key.concat "_#{args.join("_")}" if args.any?

      if !(elements = @caching_method.fetch(cache_key, @composite.full_name)).nil?
        cached_elements = elements
      else
        elements = args.any? ? @composite.public_send(name, *args) : @composite.public_send(name)
        @caching_method.store(cache_key, elements, @composite.full_name)
        cached_elements = elements
      end

      cached_elements
    end

    def respond_to_missing?(method_name, include_private = false)
      @composite.respond_to?(method_name) || super
    end

    def full_name
      @composite.full_name
    end

    def client
      @composite.client
    end
  end
end
