require 'recruiter/github_organization'
require 'recruiter/github_repository'
require 'recruiter/github_candidate/activity'
require 'recruiter/github_candidate/skills'

module Recruiter
  class GithubCandidate
    DATA_METHODS = [:name, :email, :location, :hireable, :languages, :avatar_url]

    attr_reader :client

    def initialize(data, client=Recruiter::API.build_client)
      @data = data
      @client = client
    end

    def login
      @data.login
    end

    def owned_repositories
      repositories_data('sources').map do |repo|
        Recruiter::GithubRepository.new(repo, client)
      end
    end

    def organization_list
      organization_list_data.map do |org|
        Recruiter::GithubOrganization.new(org, client)
      end
    end

    def following
      following_users_data.map do |following|
        self.class.new(following, client)
      end
    end

    def repositories(type='public')
      repositories_data(type).map do |repo|
        Recruiter::GithubRepository.new(repo, client)
      end
    end

    def repositories_contributed
      organization_list.inject([]) do |acc, org|
        repositories = org.repositories.select do |repository|
          repository.commits(login).any?
        end
        acc.concat repositories
        acc
      end
    end

    def skills
      Skills.new(self)
    end

    def activity
      Activity.new(self)
    end

    def parsed_activity
      activity.parse_activity
    end

    def languages
      skills.languages
    end

    def languages_2(repos)
      skills.languages_2(repos)
    end

    def contributions
      skills.organization_contributions
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

    # Raw Github Data Methods

    def organization_list_data
      client.organizations(login, type: 'public')
    end

    def repositories_data(type='public')
      client.auto_paginate = true
      repos = client.repositories(login, type: type)
      client.auto_paginate = false
      repos
    end

    def following_users_data
      client.auto_paginate = true
      following = client.following(login, type: 'public')
      client.auto_paginate = false
      following
    end

    def events
      events = client.user_public_events(login)
      last_response = client.last_response

      until last_response.rels[:next].nil?
        last_response = last_response.rels[:next].get
        events.concat last_response.data
      end

      events
    end
  end
end
