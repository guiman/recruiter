require 'recruiter/github_commit_analyzer'

module Recruiter
  class GithubRepository
    DATA_METHODS = [:name, :full_name, :languages, :stargazers_count, :main_language, :fork?]

    attr_reader :client

    def self.build_hash(repository)
      {
        name: repository.full_name,
        languages: repository.languages.to_hash.keys.map(&:to_s),
        popularity: repository.stargazers_count,
        main_language: repository.main_language
      }
    rescue Octokit::RepositoryUnavailable
      nil
    end

    def initialize(data, client)
      @data = data
      @client = client
    end

    def main_language
      @data.language
    end

    def languages_contributions(user=nil)
      commits = self.commits(user)

      analyzer_data = Recruiter::GithubCommitAnalyzer.analyze(self, commits)
      commit_count = analyzer_data.count
      languages_data = analyzer_data.inject(Hash.new(0)) do |acc, data|
        languages = data.fetch(:data).map { |x| x.fetch(:language) }.uniq
        languages.each { |lang| acc[lang] += 1 }
        acc
      end

      { analyzed_file_count: commit_count, languages_breakdown: languages_data }
    end

    def languages
      @data.rels[:languages].get.data.to_hash
    end

    def fork?
      @data.fork
    end

    def commits(author=nil)
      options = {}
      options[:author] = author if author

      client.auto_paginate = true
      c = client.commits(full_name, nil, options)
      client.auto_paginate = false
      c
    rescue Octokit::Conflict
      []
    rescue Octokit::NotFound
      []
    end

    def commit(sha)
      client.commit(full_name, sha)
    end

    def contributors
      client.contributors(full_name)
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
  end
end
