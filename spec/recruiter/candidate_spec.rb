require 'spec_helper'

describe Recruiter::Candidate do
  it "can create a candidate with data" do
    data = double("data",
                  fullname: "field value",
                  location: "Death star",
                  repos: 5)
    candidate = Recruiter::Candidate.new(data)

    expect(candidate.fullname).to eq("field value")
    expect(candidate.location).to eq("Death star")
    expect(candidate.repository_count).to eq(5)
  end

  it "can be turn into hash" do
    data = double("data",
                  fullname: "field value",
                  location: "Death star",
                  repos: 5)
    candidate = Recruiter::Candidate.new(data)

    allow(candidate).to receive(:hireable).and_return(true)
    allow(candidate).to receive(:email).and_return("email@domain.com")
    expect(candidate.to_hash).to eq({
      fullname: "field value",
      email: "email@domain.com",
      location:"Death star",
      repository_count: 5,
      hireable: true
    })
  end
end
