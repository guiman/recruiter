require 'spec_helper'

describe Recruiter::GithubCandidate::Activity do
  it "returns a collection of all pull_request_events" do
    activity = described_class.new(
      double(events:[
        double(type: "PullRequestEvent",
               created_at: Time.now.to_date,
               repo: double(name: "user/repo_name"),
               payload: double(action: "opened",
                               pull_request: double(merged: false,
                                                    user: double(login: "user"))))
      ])
    )
    expected_result = [
      { repository_name: "user/repo_name", action: "opened", merged: false, sender: "user", created_at: Time.now.to_date },
    ]
    expect(activity.pull_request_events).to match_array(expected_result)
  end
  it "returns a collection of all push_events" do
    activity = described_class.new(
      double(events:[
        double(type: "PushEvent",
               created_at: Time.now.to_date,
               repo: double(name: "user/repo_name"),
               payload: double(commits: [double, double, double])
        )
      ])
    )
    expected_result = [
      { repository_name: "user/repo_name", commits: 3, created_at: Time.now.to_date },
    ]
    expect(activity.push_events).to match_array(expected_result)
  end
end
