module Recruiter
  class GithubCandidate
    class Activity
      def initialize(candidate)
        @candidate = candidate
      end

      def pull_request_events
        @candidate.events.map do |event|
          if event.type == "PullRequestEvent" && ["opened", "closed"].include?(event.payload.action)
            {
              repository_name: event.repo.name,
              action: event.payload.action,
              merged: event.payload.pull_request.merged,
              sender: event.payload.pull_request.user.login,
              created_at: event.created_at
            }
          end
        end.compact
      end

      def push_events
        @candidate.events.map do |event|
          if event.type == "PushEvent"
            {
              repository_name: event.repo.name,
              commits: event.payload.commits.count,
              created_at: event.created_at
            }
          end
        end.compact
      end
    end
  end
end
