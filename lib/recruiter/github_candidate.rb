require 'recruiter/github_candidate/skills'

module Recruiter
  class GithubCandidate
    DATA_METHODS = [:fullname, :email, :location, :login, :owned_repositories_count, :hireable, :languages]

    def initialize(data)
      @data = data
    end

    def repository_count
      @data.repos
    end

    def owned_repositories_count
      owned_repositories.count
    end

    def owned_repositories
      all_repositories.select { |repository| !repository.fork }
    end

    def all_repositories
      ::Recruiter::API.build_client.user(@data.login).rels[:repos].get.data
    end

    def skills
      Skills.new(self)
    end

    def languages
      skills.languages
    end

    def email
      @email = ::Recruiter::API.build_client.user(@data.login).email
    end

    def hireable
      @hireable = ::Recruiter::API.build_client.user(@data.login).hireable
    end

    def method_missing(name)
      if DATA_METHODS.include? name
        @data.public_send(name)
      else
        super
      end
    end

    def to_hash
      DATA_METHODS.inject({}) do |acc, method|
        acc[method] = self.public_send(method)
        acc
      end
    end
  end
end
