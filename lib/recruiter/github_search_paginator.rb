module Recruiter
  class GithubSearchPaginator
    EndReached = Class.new(StandardError) do
      def message
        "Sorry, you have reached the end of the list"
      end
    end

    NoSearchInProgress = Class.new(StandardError) do
      def message
        "There is not current search in progress"
      end
    end

    def initialize(client:, redis_client: nil, search_strategy:, search_criteria: )
      @client = client
      @redis_client = redis_client
      @search_criteria = search_criteria
      @search_strategy = search_strategy.new(
        client: @client,
        redis_client: @redis_client
      )

      @current_page = 1
      @last_search = nil
    end

    def page(number)
      @last_search, raw_response = @search_strategy.all(@search_criteria, page: number)
      @current_page = number
      @search_strategy.cast_to_models(raw_response)
    end

    def result_count
      last_search.data.total_count
    end

    def current_page_number
      @current_page
    end

    def page_count
      raise NoSearchInProgress.new if last_search.nil?

      if @last_search.rels[:last].nil?
        @last_search.rels[:prev].href.match(/page=(\d+)/)[1].to_i + 1
      else
        @last_search.rels[:last].href.match(/page=(\d+)/)[1].to_i
      end
    end

    def next_page
      raise NoSearchInProgress.new if last_search.nil?
      raise EndReached.new if last_search.rels[:next].nil?

      if last_search
        @last_search = last_search.rels[:next].get
        @current_page = last_search.rels[:prev].href.match(/page=(\d+)/)[1].to_i + 1
        @raw_response = last_search.data
        @search_strategy.cast_to_models(@raw_response)
      else
        page(1)
      end
    end

    private
    attr_accessor :last_search
  end
end
