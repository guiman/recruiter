require 'recruiter/github_organization'
require 'recruiter/cached_github_repository'
require 'recruiter/redis_cache'
require 'recruiter/cache_mechanism'

module Recruiter
  class CachedGithubOrganization
    include CacheMechanism

    def initialize(organization, caching_method)
      @composite = organization
      @caching_method = caching_method
    end

    def cache_namespace
      login
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

    def repositories(type='public')
      repositories_data(type).map do |repo|
        Recruiter::CachedGithubRepository.new(Recruiter::GithubRepository.new(repo, client), @caching_method)
      end
    end
  end
end
