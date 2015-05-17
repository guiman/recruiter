require 'recruiter/github_candidate/skills'
require 'recruiter/github_candidate/activity'

module Recruiter
  class GithubCandidate
    DATA_METHODS = [:name, :email, :location, :login, :owned_repositories_count, :hireable, :languages, :avatar_url]

    attr_reader :client

    def initialize(data, client=Recruiter::API.build_client)
      @data = data
      @client = client
    end

    def owned_repositories_count
      owned_repositories.count
    end

    def owned_repositories
      all_repositories.select { |repository| !repository.fork }
    end

    def organization_list
      @data.rels[:organizations].get.data
    end

    def all_repositories
      @data.rels[:repos].get.data
    end

    def events
      # get ALL the events
      last_response = @data.rels[:events].get
      events = last_response.data

      until last_response.rels[:next].nil?
        last_response = last_response.rels[:next].get
        events.concat last_response.data
      end

      events
    end

    def skills
      Skills.new(self)
    end

    def activity
      Activity.new(self)
    end

    def languages
      skills.languages
    end

    def contributions
      skills.organization_contributions
    end

    def email
      @data.email
    end

    def hireable
      @data.hireable
    end

    def method_missing(name)
      if DATA_METHODS.include? name
        @data.public_send(name)
      else
        super
      end
    end

    def to_hash
      DATA_METHODS.inject({}) do |acc, method|
        acc[method] = self.public_send(method)
        acc
      end
    end
  end
end
