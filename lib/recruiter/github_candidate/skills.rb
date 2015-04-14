module Recruiter
  class GithubCandidate
    class Skills
      def initialize(candidate)
        @candidate = candidate
      end

      def top(count)
        @candidate.languages.sort_by{ |k,v| -v }
          .map { |pair| pair.first }
          .first(count)
      end


      def languages
        repositories = fetch_repositories
        languages = repositories.map { |langs| langs.fetch(:languages, []) }
        languages.flatten.group_by { |lang| lang }
          .map { |k,v| [k, v.count] }
          .sort_by { |pair| pair.last }
          .inject({}) do |acc, val|
            repositories_for_language = repositories.select { |repo| repo.fetch(:languages).include?(val.first) }
            acc[val.first] = repositories_for_language.map { |repo| { name: repo.fetch(:name), popularity: repo.fetch(:popularity), main_language: repo.fetch(:main_language) }  }
            acc
          end
      end

      private

      def fetch_repositories
        @candidate.owned_repositories.map do |repo|
          {
            name: repo.name,
            languages: repo.rels[:languages].get.data.to_hash.keys,
            popularity: repo.stargazers_count,
            main_language: repo.language
          }
        end
      rescue Octokit::RepositoryUnavailable
        []
      end
    end
  end
end
