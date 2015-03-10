module Recruiter
  class Candidate
    DATA_METHODS = [:fullname, :email, :location, :login, :forked_repository_count, :repository_count, :hireable, :languages]

    def initialize(data)
      @data = data
    end

    def repository_count
      @data.repos
    end

    def forked_repository_count
      ::Recruiter::API.build_client.user(@data.login).rels[:repos].get(uri: { type: 'forks'}).data.count
    end

    def languages
      ::Recruiter::API.build_client.user(@data.login).rels[:repos].get.data.map do |repo|
        repo.language
      end.compact.uniq.map(&:capitalize)
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
