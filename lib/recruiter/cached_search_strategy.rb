require 'recruiter/github_search_strategy'
require 'recruiter/cached_github_candidate'
require 'redis'

module Recruiter
  class CachedSearchStrategy
    attr_reader :composite
    def initialize(client:, redis_client:)
      @composite = ::Recruiter::GithubSearchStrategy.new(client: client, redis_client: redis_client)
      @redis_client = redis_client
      @client = client
    end

    def all(filters, page: 1)
      redis_cache_key = "#{filters}_page_#{page}"

      if cached_search = @redis_client.get(redis_cache_key)
        cached_search = Marshal.load(cached_search)
      else
        search_results = composite.all(filters, page: page)
        @redis_client.set(redis_cache_key, Marshal.dump(search_results))
        cached_search = search_results
      end

      cached_search
    end

    def cast_to_models(github_search)
      redis_cache = Recruiter::RedisCache.new(@redis_client)

      github_search.items.map do |data|
        candidate = Recruiter::GithubCandidate.new(@client.user(data.login), @client)
        Recruiter::CachedGithubCandidate.new(candidate, redis_cache)
      end
    end
  end
end
