require 'recruiter/github_candidate'
require 'recruiter/cached_github_repository'
require 'recruiter/cached_github_organization'
require 'recruiter/redis_cache'
require 'recruiter/cache_mechanism'

module Recruiter
  class CachedGithubCandidate
    include CacheMechanism

    def initialize(candidate, caching_method)
      @composite = candidate
      @caching_method = caching_method
    end

    def cache_namespace
      login
    end

    def client
      @composite.client
    end

    def login
      @composite.login
    end

    def languages_2(repos)
      skills.languages_2(repos)
    end

    def repositories_contributed
      @composite.repositories_contributed
    end

    def skills
      ::Recruiter::GithubCandidate::Skills.new(self)
    end

    def activity
      ::Recruiter::GithubCandidate::Activity.new(self)
    end

    def organization_list
      organization_list_data.map do |org|
        Recruiter::CachedGithubOrganization.new(Recruiter::GithubOrganization.new(org, client))
      end
    end

    def all_repositories
      all_repositories_data.map do |repo|
        Recruiter::CachedGithubRepository.new(Recruiter::GithubRepository.new(repo, client))
      end
    end

    def following
      following_users_data.map do |following|
        Recruiter::CachedGithubCandidate.new(Recruiter::GithubCandidate.new(following, client))
      end
    end
  end
end
