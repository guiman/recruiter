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

      def languages_2(repositories)
        files_analyzed = 0

        languages = repositories.inject({}) do |acc, repo|
          contrib = repo.languages_contributions(@candidate.login)
          files_analyzed += contrib.fetch(:analyzed_file_count)
          contrib.fetch(:languages_breakdown).each do |lang, count|
            acc[lang] ||= 0
            acc[lang] += count
          end
          acc
        end

        { analyzed_file_count: files_analyzed, languages_breakdown: languages }
      end

      def languages
        github_repositories = @candidate.owned_repositories
        languages = github_repositories.map { |repository| repository.languages.keys.map(&:to_s) }.flatten.uniq

        languages.inject({}) do |acc, language|
          repositories_for_language = github_repositories.select { |repo| repo.languages.include?(language.to_sym) }
          acc[language] = repositories_for_language.map { |repo| Recruiter::GithubRepository.build_hash(repo)  }
          acc
        end
      end

      def organization_contributions
        @candidate.organization_list.inject({}) do |acc, org|
          acc[org.login] = org.public_repositories.map do |repo|
            all_contributions = repo.contributors
            next if all_contributions == ""
            contribution = all_contributions.detect { |contributor| contributor.login == @candidate.login }

            if contribution
              repo = Recruiter::GithubRepository.build_hash(repo)
              repo[:contributions] = contribution.contributions
              repo
            end
          end.compact
          acc
        end
      end
    end
  end
end
