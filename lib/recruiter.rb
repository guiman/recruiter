require "recruiter/api"
require "recruiter/candidate"
require "recruiter/cached_search"
require "recruiter/search"
require "recruiter/version"

module Recruiter
  def search(cached: false)
    cached ? CachedSearch.new : Search.new
  end

  module_function :search
end

begin
  require 'byebug'
rescue LoadError
end
