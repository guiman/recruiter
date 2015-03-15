require "recruiter/github_candidate"
require "octokit"

module Recruiter
  class GithubSearchStrategy
    NoFilterError = Class.new(StandardError)

    def model
      ::Recruiter::GithubCandidate
    end

    def all(filters)
      ::Recruiter::API.build_client.legacy_search_users(filters).map do |data|
        model.new(data)
      end
    rescue Octokit::NotFound
      raise NoFilterError.new("You need to specify a filter to make a search")
    end
  end
end
