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
        fetch_languages_from_repositories.flatten.group_by { |lang| lang }
          .map { |k,v| [k, v.count] }
          .sort_by { |pair| pair.last }
          .inject({}) { |acc, val| acc[val.first] = val.last; acc }
      end

      private

      def fetch_languages_from_repositories
        @candidate.owned_repositories.map do |repo|
          repo.rels[:languages].get.data.to_hash.keys
        end
      rescue Octokit::RepositoryUnavailable
        []
      end
    end
  end
end
