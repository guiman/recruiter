require 'spec_helper'

describe Recruiter::GithubCandidate::Repository do
  describe "#languages" do
    it "returns a hash with languages as key and repository names that used them as values" do
      repositories = [
        { name: "ruby_and_js_repo", languages: [:ruby, :javascript], popularity: 10, main_language: :ruby },
        { name: "only_js_repo", languages: [:javascript], popularity: 5, main_language: :javascript },
        { name: "awesome_repo", languages: [:ruby, :javascript, :css], popularity: 30, main_language: :css}
      ]
      languages = described_class.languages(repositories)

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

      expect(languages).to eq(expected_result)
    end
  end
end
