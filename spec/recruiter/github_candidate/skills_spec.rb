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
    it "returns a hash with languages as key and repository names that used them as values" do
      skills = described_class.new(double)
      allow(skills).to receive(:fetch_repositories).and_return(
        [
          { name: "ruby_and_js_repo", languages: [:ruby, :javascript], popularity: 10, main_language: :ruby },
          { name: "only_js_repo", languages: [:javascript], popularity: 5, main_language: :javascript },
          { name: "awesome_repo", languages: [:ruby, :javascript, :css], popularity: 30, main_language: :css}
        ]
      )

      expected_result = {
        css: [{ name: "awesome_repo", popularity: 30, main_language: :css }],
        ruby: [
          { name: "ruby_and_js_repo", popularity: 10, main_language: :ruby },
          { name: "awesome_repo", popularity: 30, main_language: :css }
        ],
        javascript: [
          { name: "ruby_and_js_repo", popularity: 10, main_language: :ruby },
          { name: "only_js_repo", popularity: 5, main_language: :javascript },
          { name: "awesome_repo", popularity: 30, main_language: :css }
        ]
      }

      expect(skills.languages).to eq(expected_result)
    end
  end
end
