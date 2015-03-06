require 'spec_helper'

describe Recruiter do
  describe "#recruit" do
    it "returns a collection of candidates" do
      expect(Recruiter.recruit).to be_a(Array)
      expect(Recruiter.recruit.first).to be_a(Recruiter::Candidate)
    end
  end
end
