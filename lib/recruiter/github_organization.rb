module Recruiter
  class GithubOrganization
    DATA_METHODS = [:name, :email, :location, :login, :languages, :avatar_url]

    attr_reader :client

    def initialize(data, client)
      @data = data
      @client = client
    end

    def members
      @client.auto_paginate = true
      members = @client.organization_public_members(login)
      @client.auto_paginate = false
      members
    end

    def owned_repositories
      public_repositories.select { |repo| !repo.fork? }
    end

    def public_repositories
      public_repositories_data.map do |repo|
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

    def to_hash
      DATA_METHODS.inject({}) do |acc, method|
        acc[method] = self.public_send(method)
        acc
      end
    end

    def public_repositories_data
      client.org_repos(login, {:type => 'public'})
    end
  end
end
