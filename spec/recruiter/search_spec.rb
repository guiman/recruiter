require 'spec_helper'

describe Recruiter::Search do
  subject { described_class.new(client: double) }

  describe "using other strategies" do
    it "can search using a particular strategy" do
      class VerySimpleStrategy
        def initialize(client:, redis_client:)
        end

        def all(search)
          []
        end

        def cast_to_models(models)
          []
        end
      end

      search = described_class.new(search_strategy: VerySimpleStrategy, client: double)
      expect(search.all).to eq([])
    end
  end

  describe "#skills" do
    it "returns a collection of candidates with repos that include any of the mentioned skills" do
      subject.skills('Ruby,Javascript')

      expect(subject.filters).to eq('language:Ruby language:Javascript')
    end
  end

  describe "#with_repos" do
    it "returns a collection of candidates with more than 5 repositories" do
      subject.with_repos('>5')

      expect(subject.filters).to eq('repos:>5')
    end
  end

  describe "#at" do
    it "returns a collection of candidates with more than 5 repositories" do
      subject.at('Portsmouth')
      subject.and_at('Hampshire')

      expect(subject.filters).to eq('location:"Portsmouth" location:"Hampshire"')
    end
  end

  describe "filters" do
    it "returns a string representing all applied filters" do
      subject.with_repos('>5')

      expect(subject.filters).to include('repos:>5')
    end
  end
end
