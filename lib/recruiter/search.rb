require "octokit"

module Recruiter
  class Search
    def initialize(search_strategy: NoSearchStrategy, filters: [])
      @search_strategy = search_strategy.new(self)
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
      languages.split(',')
        .map { |language| "language:#{language}" }
        .inject(filters) { |acc, obj| acc << obj }
      self.class.new(filters: filters)
    end

    def filters
      @filters.join(' ')
    end

    def all
      @search_strategy.all
    end
  end
end
