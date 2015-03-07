require 'spec_helper'

describe Recruiter do
  describe "#search" do
    it "returns a collection of candidates" do
      expect(Recruiter.search).to be_a(Recruiter::Search)
    end
  end
end
