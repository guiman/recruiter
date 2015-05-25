require 'recruiter/github_organization'
require 'recruiter/cached_github_repository'
require 'redis'

module Recruiter
  class CachedGithubOrganization
    def initialize(organization)
      @organization = organization
    end

    def self.redis
      @redis ||= ::Redis.new
    end

    def method_missing(name)
      redis_cache_key = "#{@organization.login}_#{name}"
      if elements = self.class.redis.get(redis_cache_key)
        cached_elements = Marshal.load(elements)
      else
        elements = @organization.public_send(name)
        self.class.redis.set(redis_cache_key, Marshal.dump(elements))
        cached_elements = elements
      end

      cached_elements
    end

    def client
      @organization.client
    end

    def members
      members_data.map do |repo|
        Recruiter::CachedGithubCandidate.new(Recruiter::GithubCandidate.new(repo, client))
      end
    end

    def public_repositories
      public_repositories_data.map do |repo|
        Recruiter::CachedGithubRepository.new(Recruiter::GithubRepository.new(repo, client))
      end
    end
  end
end
