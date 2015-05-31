module Recruiter
  class GithubRepository
    DATA_METHODS = [:name, :full_name, :languages, :stargazers_count, :main_language, :fork?]

    attr_reader :client

    def initialize(data, client)
      @data = data
      @client = client
    end

    def main_language
      @data.language
    end

    def languages
      @data.rels[:languages].get.data
    end

    def fork?
      @data.fork
    end

    def commits
      client.commits(full_name)
    end

    def commit(sha)
      client.commit(full_name, sha)
    end

    def contributors
      client.contributors(full_name)
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
