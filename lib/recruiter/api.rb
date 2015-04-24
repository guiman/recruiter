require 'octokit'

module Recruiter
  class API
    def self.build_client(configuration: self.configuration)
      @client ||= ::Octokit::Client.new configuration
    end

    def self.configuration
      { access_token: ENV['GITHUB_ACCESS_TOKEN'] }
    end
  end
end
