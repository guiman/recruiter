require 'recruiter/github_candidate/skills'
require 'recruiter/github_candidate/activity'

module Recruiter
  class GithubOrganization
    DATA_METHODS = [:name, :email, :location, :login, :languages, :avatar_url]

    attr_reader :client

    def initialize(data, client=Recruiter::API.build_client)
      @data = data
      @client = client
    end

    def owned_repositories_count
      owned_repositories.count
    end

    def members
      @client.auto_paginate = true
      members = @client.organization_public_members(login)
      @client.auto_paginate = false
      members
    end

    def owned_repositories
      all_repositories.select { |repository| !repository.fork }
    end

    def all_repositories
      @client.org_repos(login, {:type => 'public'})
    end

    def events
      last_response = @data.rels[:events].get
      events = last_response.data

      until last_response.rels[:next].nil?
        last_response = last_response.rels[:next].get
        events.concat last_response.data
      end

      events
    end

    def skills
      Recruiter::GithubCandidate::Skills.new(self)
    end

    def activity
      Recruiter::GithubCandidate::Activity.new(self)
    end

    def languages
      skills.languages
    end

    def email
      @data.email
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
