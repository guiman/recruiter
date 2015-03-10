require "octokit"

module Recruiter
  class Search
    NoFilterError = Class.new(StandardError)

    def initialize(filters: [])
      @filters = filters
      freeze
    end

    def at(location)
      filters = @filters.dup << "location:#{location}"
      self.class.new(filters: filters)
    end
    alias_method :and_at, :at

    def with_repos(repository_filter)
      filters = @filters.dup << "repos:#{repository_filter}"
      self.class.new(filters: filters)
    end

    def skills(languages)
      filters = @filters.dup
      languages.split(',').map { |language|
        "language:#{language}" }.inject(filters) { |acc, obj| acc << obj }
      self.class.new(filters: filters)
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
