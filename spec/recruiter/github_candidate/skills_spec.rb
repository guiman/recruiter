require "spec_helper"

describe Recruiter::GithubCandidate::Skills do
  describe "#top" do
    it "returns the top 3 skills" do
      candidate = double("candidate", languages: { skill_1: 10, skill_2: 9, skill_3: 2, skill_4: 8})
      skills = described_class.new(candidate)

      expect(skills.top(3)).to match_array([:skill_1, :skill_2, :skill_4])
    end
  end

  describe "#languages" do
    it "returns a hash with languages as key and number of appearence as values" do
      skills = described_class.new(double)
      allow(skills).to receive(:fetch_languages_from_repositories).and_return(
        [
          [:ruby, :javascript], [:javascript], [:ruby, :javascript, :css]
        ]
      )
      expect(skills.languages).to eq({ ruby: 2, javascript: 3, css: 1 })
    end
  end
end
