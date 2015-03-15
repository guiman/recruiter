require "recruiter/api"
require "recruiter/candidate"
require "recruiter/no_search_strategy"
require "recruiter/search"
require "recruiter/version"

module Recruiter
  def search(search_strategy: NoSearchStrategy)
    Search.new(search_strategy: search_strategy)
  end

  module_function :search
end

begin
  require 'byebug'
rescue LoadError
end
