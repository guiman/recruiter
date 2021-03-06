require "recruiter/api"
require "recruiter/github_commit_analyzer"
require "recruiter/github_search_strategy"
require "recruiter/github_organization"
require "recruiter/search"
require "recruiter/version"

module Recruiter
  def search(search_strategy: GithubSearchStrategy, client:, redis_client: nil)
    Search.new(search_strategy: search_strategy, client: client, redis_client: redis_client)
  end

  module_function :search
end

begin
  require 'byebug'
rescue LoadError
end
