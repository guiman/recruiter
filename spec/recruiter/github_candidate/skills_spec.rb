require "spec_helper"

describe Recruiter::GithubCandidate::Skills do
  describe "#top" do
    it "returns the top 3 skills" do
      skills = described_class.new(double("candidate"))
      expect(skills).to receive(:languages).and_return({ skill_1: 10, skill_2: 9, skill_3: 2, skill_4: 8})
      expect(skills.top(3)).to match_array([:skill_1, :skill_2, :skill_4])
    end
  end
end
