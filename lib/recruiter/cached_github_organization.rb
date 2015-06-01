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

    def method_missing(name, *args)
      redis_cache_key = "#{@organization.login}_#{name}"
      redis_cache_key.concat "_#{args.join("_")}" if args.any?
      if elements = self.class.redis.get(redis_cache_key)
        cached_elements = Marshal.load(elements)
      else
        elements = args.any? ? @organization.public_send(name, *args) : @organization.public_send(name)
        self.class.redis.set(redis_cache_key, Marshal.dump(elements))
        cached_elements = elements
      end

      cached_elements
    end

    def client
      @organization.client
    end

    def skills
      ::Recruiter::GithubCandidate::Skills.new(self)
    end

    def activity
      ::Recruiter::GithubCandidate::Activity.new(self)
    end

    def members
      members_data.map do |repo|
        Recruiter::CachedGithubCandidate.new(Recruiter::GithubCandidate.new(repo, client))
      end
    end

    def repositories(include_private=false)
      repositories_data(include_private).map do |repo|
        Recruiter::CachedGithubRepository.new(Recruiter::GithubRepository.new(repo, client))
      end
    end
  end
end
