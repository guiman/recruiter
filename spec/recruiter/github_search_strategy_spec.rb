require "spec_helper"

describe Recruiter::GithubSearchStrategy do
  describe "#all" do
    it "fetches results from GithubAPI" do
      github_client = double
      github_search = double("search", items: [ double(login: "test") ])

      strategy = described_class.new(client: github_client)

      allow(Recruiter::API).to receive(:build_client).and_return(github_client)
      expect(github_client).to receive(:search_users).and_return(github_search)
      expect(github_client).to receive(:last_response)

      strategy.all("fake:search")
    end

    it "raises a no filter error" do
      strategy = described_class.new(client: Recruiter::API.build_client)

      expect { strategy.all('') }.to raise_error(Recruiter::GithubSearchStrategy::NoFilterError)
    end
  end
end
