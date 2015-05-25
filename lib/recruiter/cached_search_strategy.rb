require 'recruiter/github_search_strategy'
require 'recruiter/cached_github_candidate'
require 'redis'

module Recruiter
  class CachedSearchStrategy
    attr_reader :composite
    def initialize(client:)
      @composite = ::Recruiter::GithubSearchStrategy.new(client: client)
      @client = client
    end

    def self.redis
      @redis ||= ::Redis.new
    end

    def all(filters, page: 1)
      redis_cache_key = "#{filters}_page_#{page}"

      if cached_search = self.class.redis.get(redis_cache_key)
        cached_search = Marshal.load(cached_search)
      else
        search_results = composite.all(filters, page: page)
        self.class.redis.set(redis_cache_key, Marshal.dump(search_results))
        cached_search = search_results
      end

      cached_search
    end

    def cast_to_models(github_search)
      github_search.items.map do |data|
        Recruiter::CachedGithubCandidate.new(Recruiter::GithubCandidate.new(@client.user(data.login), @client))
      end
    end
  end
end
