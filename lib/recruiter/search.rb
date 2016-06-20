require 'recruiter/github_search_paginator'
require 'forwardable'

module Recruiter
  class Search
    extend Forwardable

    def initialize(search_strategy: GithubSearchStrategy, client:, redis_client: nil)
      @search_strategy = search_strategy
      @filters = []
      @client = client
      @redis_client = redis_client
    end

    def at(location)
      @filters << "location:\"#{location}\""
    end
    alias_method :and_at, :at

    def with_repos(repository_filter)
      @filters << "repos:#{repository_filter}"
    end

    def skills(languages)
      languages.split(',')
        .map { |language| "language:#{language}" }
        .inject(@filters) { |acc, obj| acc << obj }
    end

    def filters
      @filters.join(' ')
    end

    def clear_filters
      @filters = []
    end

    def all
      @paginator ||= Recruiter::GithubSearchPaginator.new(
        client: @client,
        redis_client: @redis_client,
        search_strategy: @search_strategy,
        search_criteria: filters
      )

      @paginator.page(1)
    end

    def_delegators :@paginator, :page, :results, :current_page_number, :page_count,
      :next_page
  end
end
