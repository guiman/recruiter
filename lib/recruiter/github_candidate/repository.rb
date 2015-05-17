module Recruiter
  class GithubCandidate
    class Repository
      def self.build(repository)
        {
          name: repository.name,
          languages: repository.rels[:languages].get.data.to_hash.keys,
          popularity: repository.stargazers_count,
          main_language: repository.language
        }
      end

      def self.build_from_github_repositories(github_repositories)
        github_repositories.map do |repo|
          Proc.new do
            begin
              build(repo)
            rescue Octokit::RepositoryUnavailable
              nil
            end
          end.call
        end
      end

      def self.languages(repositories)
        # We want to get all the languages
        languages = repositories.map { |langs| langs.fetch(:languages, []) }
        # With a propper list of languages, we then group by languages
        languages.flatten.
          group_by { |lang| lang }.
          # Then we identify how many repetitions of the language are there
          map { |k,v| [k, v.count] }.
          # We sort then by repetition, first being the one with more repetitions
          sort_by { |pair| pair.last }.
          # Least but not last, now that we know how many of each language we
          # have. We build a hash with repositories for each language
          inject({}) do |acc, val|
            repositories_for_language = repositories.select { |repo| repo.fetch(:languages).include?(val.first) }
            acc[val.first] = repositories_for_language.map { |repo| { name: repo.fetch(:name), popularity: repo.fetch(:popularity), main_language: repo.fetch(:main_language) }  }
            acc
          end
      end
    end
  end
end
