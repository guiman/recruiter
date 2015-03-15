module Recruiter
  class GithubCandidate
    class Skills
      def initialize(candidate)
        @candidate = candidate
      end

      def top(count)
        @candidate.languages.sort_by{ |k,v| -v }
          .map { |pair| pair.first }
          .slice(0..3)
      end
    end
  end
end
