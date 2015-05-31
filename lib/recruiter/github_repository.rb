module Recruiter
  class GithubRepository
    DATA_METHODS = [:name, :full_name, :languages, :stargazers_count, :main_language, :fork?]

    attr_reader :client

    def initialize(data, client)
      @data = data
      @client = client
    end

    def main_language
      @data.language
    end

    def languages_contributions(user=nil)
      commits = if user
        self.commits.select { |commit| commit.author && commit.author.login == user }
      else
        self.commits
      end

      analyzer_data = Recruiter::GithubCommitAnalyzer.analyze(self, commits)

      languages = analyzer_data.map { |x| x.fetch(:data).map { |y| y.fetch(:language) } }.flatten.uniq
      languages_data = languages.inject({}) { |acc, lang| acc[lang] = 0; acc  }

      analyzer_data.each do |commit_data|
        commit_data_by_language = commit_data.fetch(:data).group_by { |file| file.fetch(:language) }
        commit_data_by_language.each do |lang, data|
          # Count of files for the language
          languages_data[lang] += data.count
        end
      end

      { commit_count: commits.count, languages_breakdown: languages_data }
    end

    def languages
      @data.rels[:languages].get.data
    end

    def fork?
      @data.fork
    end

    def commits
      client.commits(full_name)
    rescue Octokit::Conflict
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

    def to_hash
      DATA_METHODS.inject({}) do |acc, method|
        acc[method] = self.public_send(method)
        acc
      end
    end
  end
end
