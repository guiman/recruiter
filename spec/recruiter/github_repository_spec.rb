require 'spec_helper'

describe Recruiter::GithubRepository do
  let(:client) { Recruiter::API.build_client(configuration: { access_token: ENV.fetch("GITHUB_ACCESS_TOKEN") } ) }
  let(:github_data) { double("github_commit_data", full_name: "guiman/baku") }
  subject { Recruiter::GithubRepository.new(github_data, client) }

  describe "#languages_contributions" do
    it "filters contributions by author" do
      expect(subject.languages_contributions("dpaez")).to eq({
          analyzed_file_count: 13,
          languages_breakdown: {
            "Ruby"=>5,
            "JavaScript"=>8,
            "JSON"=>4,
            "Markdown"=>6,
            nil=>2,
            "CSS"=>1,
            "Stylus"=>1,
            "Jade"=>3
          }
        })
    end
    it "returns language breakdown and commits for all authors" do
      expect(subject.languages_contributions).to eq({
          analyzed_file_count: 45,
          languages_breakdown: {
            "JavaScript"=>25,
            "Ruby"=>25,
            "Jade"=>4,
            "JSON"=>7,
            "Markdown"=>13,
            nil=>2,
            "CSS"=>1,
            "Stylus"=>1
          }
        })
    end
  end
end
