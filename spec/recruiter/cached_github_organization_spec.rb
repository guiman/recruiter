require 'spec_helper'
require 'recruiter/cached_github_organization'

describe Recruiter::CachedGithubOrganization do
  it "caches requests" do
    client = Recruiter::API.build_client(configuration: {
      access_token: ENV.fetch("GITHUB_ACCESS_TOKEN") } )
    github_data = client.org("github")
    caching_method = Recruiter::RedisCache.new

    org  = Recruiter::GithubOrganization.new(github_data, client)
    cached_org = Recruiter::CachedGithubOrganization.new(org, caching_method)

    # Clearing namespece from cache
    caching_method.remove_namespace("github")

    expect(github_data).to receive(:name).once.and_call_original

    cached_org.name
    cached_org.name
  end

  it "doesn't cache login" do
    github_data = double("data", login: "devhubio")
    caching_method = Recruiter::RedisCache.new
    org = Recruiter::GithubOrganization.new(github_data, double)
    cached_org = Recruiter::CachedGithubOrganization.new(org, caching_method)

    expect(github_data).to receive(:login).twice

    cached_org.login
    cached_org.login
  end
end
