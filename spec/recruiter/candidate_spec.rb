require 'spec_helper'

describe Recruiter::Candidate do
  it "can create a candidate with data" do
    data = double("data",
                  fullname: "field value",
                  email: "email",
                  location: "Death star")
    candidate = Recruiter::Candidate.new(data)

    expect(candidate.fullname).to eq("field value")
    expect(candidate.email).to eq("email")
    expect(candidate.location).to eq("Death star")
  end

  it "can be turn into hash" do
    data = double("data",
                  fullname: "field value",
                  email: "email@domain.com",
                  location: "Death star")
    candidate = Recruiter::Candidate.new(data)

    expect(candidate.to_hash).to eq({
      fullname: "field value",
      email: "email@domain.com",
      location:"Death star"
    })
  end
end
