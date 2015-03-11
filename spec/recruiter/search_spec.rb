require 'spec_helper'

describe Recruiter::Search do
  describe "#all" do
    it "raises a no filter error" do
      expect { Recruiter.search.all }.to raise_error(Recruiter::Search::NoFilterError)
    end

    it "returns a collection of candidates" do
      candidates = Recruiter.search.with_repos('>5').all

      expect(candidates).to be_a(Array)
      expect(candidates.first).to be_a(Recruiter::Candidate)
    end
  end

  describe "#skills" do
    it "returns a collection of candidates with repos that include any of the mentioned skills" do
      candidates = Recruiter.search.skills('Ruby,Javascript').all

      expect(candidates.first.languages.map(&:first)).to include('Ruby', 'Javascript')
    end
  end

  describe "#with_repos" do
    it "returns a collection of candidates with more than 5 repositories" do
      candidates = Recruiter.search.with_repos('>5').all

      expect(candidates.first.repository_count).to be > 5
    end
  end

  describe "#at" do
    it "returns a collection of candidates with more than 5 repositories" do
      candidates = Recruiter.search.at('Portsmouth, Hampshire').all

      expect(candidates.first.location).to include("Portsmouth")
    end
  end

  describe "filters" do
    it "returns a string representing all applied filters" do
      search = Recruiter::Search.new.with_repos('>5')

      expect(search.filters).to include('repos:>5')
    end
  end
end
