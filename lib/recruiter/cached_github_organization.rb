require 'recruiter/github_organization'
require 'recruiter/cached_github_repository'
require 'recruiter/redis_cache'

module Recruiter
  class CachedGithubOrganization
    def initialize(organization, caching_method)
      @composite = organization
      @caching_method = caching_method
    end

    def method_missing(name, *args)
      cache_key = name.to_s
      cache_key.concat "_#{args.join("_")}" if args.any?

      if !(elements = @caching_method.fetch(cache_key, @composite.login)).nil?
        cached_elements = elements
      else
        elements = args.any? ? @composite.public_send(name, *args) : @composite.public_send(name)
        @caching_method.store(cache_key, elements, @composite.login)
        cached_elements = elements
      end

      cached_elements
    end

    def respond_to_missing?(method_name, include_private = false)
      @composite.respond_to?(method_name) || super
    end

    def login
      @composite.login
    end

    def client
      @composite.client
    end

    def skills
      ::Recruiter::GithubCandidate::Skills.new(self)
    end

    def activity
      ::Recruiter::GithubCandidate::Activity.new(self)
    end

    def members
      members_data.map do |repo|
        Recruiter::CachedGithubCandidate.new(Recruiter::GithubCandidate.new(repo, client), @caching_method)
      end
    end

    def repositories(include_private=false)
      repositories_data(include_private).map do |repo|
        Recruiter::CachedGithubRepository.new(Recruiter::GithubRepository.new(repo, client), @caching_method)
      end
    end
  end
end
