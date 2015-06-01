require 'spec_helper'
require 'recruiter/cached_search_strategy'

describe Recruiter do
  describe "#search" do
    it "returns a search object" do
      expect(Recruiter.search(client: double)).to be_a(Recruiter::Search)
    end
    it "accepts different strategies" do
      expect(Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy, client: double)).to be_a(Recruiter::Search)
    end
  end
end
