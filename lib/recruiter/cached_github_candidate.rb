require 'recruiter/github_candidate'
require 'recruiter/cached_github_repository'
require 'recruiter/cached_github_organization'
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

    def respond_to_missing?(method_name, include_private = false)
      @candidate.respond_to?(method_name) || super
    end

    def client
      @candidate.client
    end

    def login
      @candidate.login
    end

    def languages_2(repos)
      skills.languages_2(repos)
    end

    def repositories_contributed
      @candidate.repositories_contributed
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
