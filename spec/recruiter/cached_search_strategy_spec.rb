require "spec_helper"
require 'recruiter/cached_search_strategy'

describe Recruiter::CachedSearchStrategy do
  describe "#all" do
    it "uses a cache mechanism to return a search" do
      redis_client = Redis.new
      redis_client.del('fake search') # remove key from redis
      strategy = described_class.new(client: double, redis_client: redis_client)

      composite = double
      allow(strategy).to receive(:composite).and_return(composite)
      expect(composite).to receive(:all).with('fake search', page: 1).once.and_return([])

      result = strategy.all('fake search')
      expect(strategy.all('fake search')).to eq(result)
    end
  end
end
