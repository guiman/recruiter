require 'spec_helper'
require 'recruiter/cached_github_repository'

describe Recruiter::CachedGithubRepository do
  it "caches requests" do
    client = Recruiter::API.build_client(configuration: {
      access_token: ENV.fetch("GITHUB_ACCESS_TOKEN") } )
    github_data = client.repo("octokit/octokit.rb")
    caching_method = Recruiter::RedisCache.new

    repo  = Recruiter::GithubRepository.new(github_data, client)
    cached_repo = Recruiter::CachedGithubRepository.new(repo, caching_method)

    # Clearing namespece from cache
    caching_method.remove_namespace("octokit/octokit.rb")

    expect(repo).to receive(:commits).with("pengwynn").once.and_call_original

    cached_repo.commits("pengwynn")
    cached_repo.commits("pengwynn")
  end

  it "doesn't cache full_name" do
    github_data = double("data", login: "octokit/octokit.rb")
    caching_method = Recruiter::RedisCache.new
    repo = Recruiter::GithubRepository.new(github_data, double)
    cached_repo = Recruiter::CachedGithubRepository.new(repo, caching_method)

    expect(github_data).to receive(:full_name).twice

    cached_repo.full_name
    cached_repo.full_name
  end
end
