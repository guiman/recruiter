require 'spec_helper'

describe Recruiter::Search do
  describe "#skills" do
    it "returns a collection of candidates with repos that include any of the mentioned skills" do
      search = subject.skills('Ruby,Javascript')

      expect(search.filters).to eq('language:Ruby language:Javascript')
    end
  end

  describe "#with_repos" do
    it "returns a collection of candidates with more than 5 repositories" do
      search = subject.with_repos('>5')

      expect(search.filters).to eq('repos:>5')
    end
  end

  describe "#at" do
    it "returns a collection of candidates with more than 5 repositories" do
      search = subject.at('Portsmouth').and_at('Hampshire')

      expect(search.filters).to eq('location:Portsmouth location:Hampshire')
    end
  end

  describe "filters" do
    it "returns a string representing all applied filters" do
      search = subject.with_repos('>5')

      expect(search.filters).to include('repos:>5')
    end
  end
end
