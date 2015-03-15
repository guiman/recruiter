require 'spec_helper'

describe Recruiter::GithubCandidate do
  it "can create a candidate with data" do
    data = double("data",
                  fullname: "field value",
                  location: "Death star",
                  repos: 5)
    candidate = Recruiter::GithubCandidate.new(data)

    expect(candidate.fullname).to eq("field value")
    expect(candidate.location).to eq("Death star")
    expect(candidate.repository_count).to eq(5)
  end

  it "can be turn into hash" do
    data = double("data",
                  fullname: "field value",
                  location: "Death star",
                  login: "darthvader",
                  repos: 5)
    candidate = Recruiter::GithubCandidate.new(data)

    allow(candidate).to receive(:hireable)
    allow(candidate).to receive(:email)
    allow(candidate).to receive(:languages)
    allow(candidate).to receive(:owned_repositories_count)
    expect(candidate.to_hash.keys).to match_array([:fullname,:email,:location,:login,:owned_repositories_count,:hireable, :languages])
  end
end
