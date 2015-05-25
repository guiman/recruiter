require 'recruiter/github_candidate/repository'

module Recruiter
  class GithubCandidate
    class Skills
      def initialize(candidate)
        @candidate = candidate
      end

      def top(count)
        languages.sort_by{ |k,v| -v }
          .map { |pair| pair.first }
          .first(count)
      end

      def languages
        repositories = Recruiter::GithubCandidate::Repository.build_from_github_repositories(@candidate.owned_repositories)
        Recruiter::GithubCandidate::Repository.languages(repositories)
      end

      def organization_contributions
        @candidate.organization_list.map do |org|
          contributions = org.public_repositories.map do |repo|
            all_contributions = repo.contributors
            next if all_contributions == ""
            contribution = all_contributions.detect { |contributor| contributor.login == @candidate.login }
            {
              repo: repo.full_name,
              popularity: repo.stargazers_count,
              main_language: repo.main_language,
              contributions: contribution.contributions
            } if contribution
          end

          { org.login => contributions.compact }
        end
      end
    end
  end
end
