require 'rugged'
require 'linguist'

module Recruiter
  class GithubCommitAnalyzer
    def self.analyze(repository, commits)
      commits.map do |commit|
        author = commit.author.nil? ? nil : commit.author.login

        data = repository.commit(commit.sha)[:files].map do |file_info|
          language = Linguist::Language.find_by_filename(file_info.filename).first
          language = language.name if language
          { file: file_info.filename, del: file_info.deletions, add: file_info.additions, language: language }
        end

        {
          author: author,
          data: data
        }
      end.flatten.compact
    end
  end
end
