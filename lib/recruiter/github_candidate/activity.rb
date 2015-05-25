module Recruiter
  class GithubCandidate
    class Activity
      EVENT_WHITELIST = ['CreateEvent', 'ForkEvent', 'IssueCommentEvent',
        'IssueCommentEvent', 'IssuesEvent', 'MemberEvent', 'PublicEvent',
        'PushEvent', 'ReleaseEvent', 'RepositoryEvent']

      def initialize(candidate)
        @candidate = candidate
      end

      def self.build(event)
        {
          event_type: event.type,
          created_at: event.created_at,
          repository: nil,
          language: nil,
          updated_at: event.created_at
        }
      end

      def parse_activity
        @activity ||= @candidate.events.map do |event|
          parsed_event = self.class.build(event)

          if EVENT_WHITELIST.include? event.type
            parsed_event[:repository] = event.repo.name
            begin
              repository = @candidate.client.repository(event.repo.name)
              parsed_event[:language] = repository.language if !repository.nil?
            rescue Octokit::NotFound
            end
          end

          if event.type = 'CommitCommentEvent' && !event.payload.pull_request.nil?
            parsed_event[:repository] = event.repo.name
            if event.payload.pull_request.head.repo.nil?
              parsed_event[:language] = event.payload.pull_request.base.repo.language
            else
              parsed_event[:language] = event.payload.pull_request.head.repo.language
            end
          end

          if event.type == 'PullRequestReviewCommentEvent'
            parsed_event[:repository] = event.repo.name
            if event.payload.pull_request.head.repo.nil?
              parsed_event[:language] = event.payload.pull_request.base.repo.language
            else
              parsed_event[:language] = event.payload.pull_request.head.repo.language
            end
          end

          if event.type == 'PullRequestEvent'
            parsed_event[:repository] = event.repo.name
            if event.payload.pull_request.head.repo.nil?
              parsed_event[:language] = event.payload.pull_request.base.repo.language
            else
              parsed_event[:language] = event.payload.pull_request.head.repo.language
            end
            parsed_event[:updated_at] = event.updated_at
          end

          parsed_event
        end
      end
    end
  end
end
