module Recruiter
  class Candidate
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
      @repositories ||= ::Recruiter::API.build_client.user(@data.login).rels[:repos].get.data
    end

    def forked_repository_count
      repository_count - owned_repositories.count
    end

    def languages
      owned_repositories.map { |repo| repo.language }.compact.uniq.map(&:capitalize)
    end

    def email
      @email ||= ::Recruiter::API.build_client.user(@data.login).email
    end

    def hireable
      @hireable ||= ::Recruiter::API.build_client.user(@data.login).hireable
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
