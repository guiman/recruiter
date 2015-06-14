require "recruiter/github_candidate"
require "octokit"

module Recruiter
  class GithubSearchStrategy
    NoFilterError = Class.new(StandardError)

    def initialize(client:, redis_client:nil)
      @client = client
    end

    def model
      ::Recruiter::GithubCandidate
    end

    def all(filters, page: 1)
      result = @client.search_users(filters, page: page)
      [@client.last_response, result]
    rescue Octokit::UnprocessableEntity
      raise NoFilterError.new("You need to specify a filter to make a search")
    end

    def cast_to_models(github_search)
      github_search.items.map do |data|
        model.new(@client.user(data.login), @client)
      end
    end
  end
end
