require "spec_helper"

describe Recruiter::GithubSearchStrategy do
  describe "#all" do
    it "fetches results from GithubAPI" do
      strategy = described_class.new

      github_client = double
      github_search = double("search", items: [ double(login: "test") ])

      allow(Recruiter::API).to receive(:build_client).and_return(github_client)
      expect(github_client).to receive(:search_users).and_return(github_search)
      expect(github_client).to receive(:user).and_return(double)

      expect(strategy.all("fake:search").first).to be_a(Recruiter::GithubCandidate)
    end

    it "raises a no filter error" do
      strategy = described_class.new

      expect { strategy.all('') }.to raise_error(Recruiter::GithubSearchStrategy::NoFilterError)
    end
  end
end
