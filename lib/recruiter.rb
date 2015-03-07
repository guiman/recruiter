require "recruiter/api"
require "recruiter/candidate"
require "recruiter/search"
require "recruiter/version"

module Recruiter
  def search
    Search.new
  end

  module_function :search
end

begin
  require 'byebug'
rescue LoadError
end
