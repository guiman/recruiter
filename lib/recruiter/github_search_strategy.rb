require "recruiter/github_candidate"
require "octokit"

module Recruiter
  class GithubSearchStrategy
    NoFilterError = Class.new(StandardError)

    def model
      ::Recruiter::GithubCandidate
    end

    def all(filters)
      ::Recruiter::API.build_client.search_users(filters).items.map do |data|
        model.new(::Recruiter::API.build_client.user(data.login))
      end
    rescue Octokit::UnprocessableEntity
      raise NoFilterError.new("You need to specify a filter to make a search")
    end
  end
end
