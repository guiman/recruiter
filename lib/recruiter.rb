require "recruiter/api"
require "recruiter/github_search_strategy"
require "recruiter/github_organization"
require "recruiter/search"
require "recruiter/version"

module Recruiter
  def search(search_strategy: GithubSearchStrategy, client:)
    Search.new(search_strategy: search_strategy, client: client)
  end

  module_function :search
end

begin
  require 'byebug'
rescue LoadError
end
