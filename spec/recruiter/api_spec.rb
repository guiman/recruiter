require 'spec_helper'

describe Recruiter::API do
  describe ".build_client" do
    it "returns a configured Octokit::Client instance" do
      expect(described_class.build_client).to be_a(Octokit::Client)
    end
  end

  describe ".configuration" do
    it "returns a hash with the access_token" do
      allow(ENV).to receive(:[]).with("GITHUB_ACCESS_TOKEN").and_return("123")
      expect(described_class.configuration).to eq({access_token: "123"})
    end
  end
end
