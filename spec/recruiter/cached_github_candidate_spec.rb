require 'spec_helper'
require 'recruiter/cached_github_candidate'

describe Recruiter::CachedGithubCandidate do
  it "caches requests" do
    client = Recruiter::API.build_client(configuration: {
      access_token: ENV.fetch("GITHUB_ACCESS_TOKEN") } )
    github_data = client.user("guiman")
    caching_method = Recruiter::RedisCache.new

    candidate = Recruiter::GithubCandidate.new(github_data, client)
    cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

    # Clearing namespece from cache
    caching_method.remove_namespace("guiman")

    expect(github_data).to receive(:hireable).once.and_call_original

    cached_candidate.hireable
    cached_candidate.hireable
  end

  it "doesn't cache login" do
    github_data = double("data", login: "guiman")
    caching_method = Recruiter::RedisCache.new
    candidate = Recruiter::GithubCandidate.new(github_data, double)
    cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

    expect(github_data).to receive(:login).twice

    cached_candidate.login
    cached_candidate.login
  end
end
