require 'spec_helper'

describe Recruiter::Candidate::Skills do
  it "can return the top 3" do
    candidate = double("candidate", languages: { Swift: 1, Bash: 1, Ruby: 10, JavaScript:3, CSS: 4 })
    skills = described_class.new(candidate)
    expect(skills.top(3)).to include(:Ruby, :JavaScript, :CSS)
  end
end
