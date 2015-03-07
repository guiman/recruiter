require "octokit"

module Recruiter
  class Search
    NoFilterError = Class.new(StandardError)

    def initialize
      @filters = []
    end

    def at(location)
      @filters << "location:#{location}"
      self
    end
    alias_method :and_at, :at

    def with_repos(repository_filter)
      @filters << "repos:#{repository_filter}"
      self
    end

    def filters
      @filters.join(' ')
    end

    def all
      ::Recruiter::API.build_client.legacy_search_users(filters).map do |data|
        ::Recruiter::Candidate.new(data)
      end
    rescue Octokit::NotFound
      raise NoFilterError.new("You need to specify a filter to make a search")
    end
  end
end
