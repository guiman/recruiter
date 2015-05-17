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
          contributions = org.rels[:repos].get.data.map do |repo|
            all_contributions = @candidate.client.contributors("#{repo.full_name}")
            next if all_contributions == ""
            contribution = all_contributions.detect { |contributor| contributor.login == @candidate.login }
            {
              repo: repo.full_name,
              popularity: repo.stargazers_count,
              main_language: repo.language,
              contributions: contribution.contributions
            } if contribution
          end

          { org.login => contributions.compact }
        end
      end
    end
  end
end
