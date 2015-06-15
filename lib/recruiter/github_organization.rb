module Recruiter
  class GithubOrganization
    DATA_METHODS = [:name, :email, :location, :login, :languages, :avatar_url]

    attr_reader :client

    def initialize(data, client)
      @data = data
      @client = client
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

    def members(type='public')
      members_data(type).map do |member|
        Recruiter::GithubCandidate.new(member, client)
      end
    end

    def members_data(type='public')
      client.auto_paginate = true

      members = if type == 'all'
        client.organization_members(login)
      else
        client.organization_public_members(login)
      end

      client.auto_paginate = false
      members
    end

    def repositories(type='public')
      repositories_data(type).map do |repo|
        Recruiter::GithubRepository.new(repo, client)
      end
    end

    def method_missing(name)
      if DATA_METHODS.include? name
        @data.public_send(name)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      DATA_METHODS.include?(method_name) || super
    end

    def to_hash
      DATA_METHODS.inject({}) do |acc, method|
        acc[method] = self.public_send(method)
        acc
      end
    end

    def repositories_data(type='public')
      client.auto_paginate = true
      repos = client.org_repos(login, {:type => type})
      client.auto_paginate = false
      repos
    end

    def events
      events = client.organization_public_events(login)
      last_response = client.last_response

      until last_response.rels[:next].nil?
        last_response = last_response.rels[:next].get
        events.concat last_response.data
      end

      events
    end
  end
end
