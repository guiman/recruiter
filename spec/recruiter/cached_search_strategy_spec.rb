require "spec_helper"
require 'recruiter/cached_search_strategy'

describe Recruiter::CachedSearchStrategy do
  describe "#all" do
    it "uses a cache mechanism to return a search" do
      Redis.new.del('fake search') # remove key from redis
      composite = double
      strategy = described_class.new(composite: composite)
      expect(composite).to receive(:all).with('fake search').once.and_return([])

      result = strategy.all('fake search')
      expect(strategy.all('fake search')).to eq(result)
    end
  end
end
