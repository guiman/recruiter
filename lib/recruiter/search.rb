module Recruiter
  class Search
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

    def all
      @search_strategy_instance ||= @search_strategy.new(client: @client, redis_client: @redis_client)
      @last_search, @raw_response = @search_strategy_instance.all(filters)
      @current_page = 1
      @parsed_response = @search_strategy_instance.cast_to_models(@raw_response)
    end

    def page(number)
      @search_strategy_instance ||= @search_strategy.new(client: @client, redis_client: @redis_client)
      @last_search, @raw_response = @search_strategy_instance.all(filters, page: number)
      @current_page = number
      @parsed_response = @search_strategy_instance.cast_to_models(@raw_response)
    end

    def results
      @last_search.data.total_count
    end

    def current_page_number
      @current_page
    end

    def page_count
      if @last_search.rels[:last].nil?
        @last_search.rels[:prev].href.match(/page=(\d+)/)[1].to_i + 1
      else
        @last_search.rels[:last].href.match(/page=(\d+)/)[1].to_i
      end
    end

    def next_page
      return nil if @last_search.rels[:next].nil?

      @last_search = @last_search.rels[:next].get

      if @last_search.rels[:prev].nil?
        @current_page = 1
      else
        @current_page = @last_search.rels[:prev].href.match(/page=(\d+)/)[1].to_i + 1
      end

      @raw_response = @last_search.data
      @parsed_response = @search_strategy_instance.cast_to_models(@raw_response)
    end
  end
end
