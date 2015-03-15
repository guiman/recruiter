module Recruiter
  class NoSearchStrategy
    NoFilterError = Class.new(StandardError)

    def initialize(search)
      @search = search
    end

    def model
      ::Recruiter::Candidate
    end

    def all
      ::Recruiter::API.build_client.legacy_search_users(@search.filters).map do |data|
        model.new(data)
      end
    rescue Octokit::NotFound
      raise NoFilterError.new("You need to specify a filter to make a search")
    end
  end
end
