require "spec_helper"

describe Recruiter::GithubSearchStrategy do
  describe "#all" do
    it "fetches results from GithubAPI" do
      strategy = described_class.new

      github_client = double
      expect(Recruiter::API).to receive(:build_client).and_return(github_client)
      expect(github_client).to(
        receive(:legacy_search_users).and_return([{ fake_data: "more fake data" }]))

      expect(strategy.all("fake:search").first).to be_a(Recruiter::GithubCandidate)
    end

    it "raises a no filter error" do
      strategy = described_class.new

      expect { strategy.all('') }.to raise_error(Recruiter::GithubSearchStrategy::NoFilterError)
    end
  end
end
