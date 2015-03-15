require "spec_helper"

describe Recruiter::NoSearchStrategy do
  describe "#all" do
    it "fetches results from GithubAPI" do
      strategy = described_class.new(double("search", filters: ""))

      github_client = double
      expect(Recruiter::API).to receive(:build_client).and_return(github_client)
      expect(github_client).to receive(:legacy_search_users).and_return([{ fake_data: "more fake data" }])

      expect(strategy.all.first).to be_a(Recruiter::Candidate)
    end

    it "raises a no filter error" do
      strategy = described_class.new(double(filters: ''))

      expect { strategy.all }.to raise_error(Recruiter::NoSearchStrategy::NoFilterError)
    end
  end
end
