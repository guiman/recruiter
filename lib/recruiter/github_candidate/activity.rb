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
          main_language: nil,
          popularity: nil,
          updated_at: event.created_at
        }
      end

      def parse_activity
        @activity ||= @candidate.events.map do |event|
          parsed_event = self.class.build(event)

          if EVENT_WHITELIST.include? event.type
            parsed_event[:repository] = event.repo.name
            begin
              repository = @candidate.client.repository(event.repo.full_name)
              parsed_event[:main_language] = repository.language if !repository.nil?
              parsed_event[:popularity] = repository.stargazers_count if !repository.nil?
            rescue Octokit::NotFound
            end
          end

          if event.type = 'CommitCommentEvent' && !event.payload.pull_request.nil?
            parsed_event[:repository] = event.repo.name
            if event.payload.pull_request.head.repo.nil?
              parsed_event[:main_language] = event.payload.pull_request.base.repo.language
              parsed_event[:popularity] = event.payload.pull_request.base.repo.stargazers_count
            else
              parsed_event[:main_language] = event.payload.pull_request.head.repo.language
              parsed_event[:popularity] = event.payload.pull_request.head.repo.stargazers_count
            end
          end

          if event.type == 'PullRequestReviewCommentEvent'
            parsed_event[:repository] = event.repo.name
            if event.payload.pull_request.head.repo.nil?
              parsed_event[:main_language] = event.payload.pull_request.base.repo.language
              parsed_event[:popularity] = event.payload.pull_request.base.repo.stargazers_count
            else
              parsed_event[:main_language] = event.payload.pull_request.head.repo.language
              parsed_event[:popularity] = event.payload.pull_request.head.repo.stargazers_count
            end
          end

          if event.type == 'PullRequestEvent'
            parsed_event[:repository] = event.repo.name
            if event.payload.pull_request.head.repo.nil?
              parsed_event[:main_language] = event.payload.pull_request.base.repo.language
              parsed_event[:popularity] = event.payload.pull_request.base.repo.stargazers_count
            else
              parsed_event[:main_language] = event.payload.pull_request.head.repo.language
              parsed_event[:popularity] = event.payload.pull_request.head.repo.stargazers_count
            end
            parsed_event[:updated_at] = event.updated_at
          end

          parsed_event
        end
      end
    end
  end
end
