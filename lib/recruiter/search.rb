module Recruiter
  class Search
    def initialize(search_strategy: GithubSearchStrategy, filters: [])
      @search_strategy = search_strategy
      @filters = filters
      freeze
    end

    def at(location)
      filters = @filters.dup << "location:#{location}"
      self.class.new(filters: filters, search_strategy: @search_strategy)
    end
    alias_method :and_at, :at

    def with_repos(repository_filter)
      filters = @filters.dup << "repos:#{repository_filter}"
      self.class.new(filters: filters, search_strategy: @search_strategy)
    end

    def skills(languages)
      filters = @filters.dup
      languages.split(',')
        .map { |language| "language:#{language}" }
        .inject(filters) { |acc, obj| acc << obj }
      self.class.new(filters: filters, search_strategy: @search_strategy)
    end

    def filters
      @filters.join(' ')
    end

    def all
      @search_strategy.new.all(filters)
    end
  end
end
