require "recruiter/api"
require "recruiter/candidate"
require "recruiter/version"
require "octokit"

module Recruiter
  def recruit
    users = API.build_client.legacy_search_users("repos:>5")
    users.map { |data| Candidate.new(data) }
  end

  module_function :recruit
end

begin
  require 'byebug'
rescue LoadError
end
