require 'spec_helper'
require 'recruiter/cached_github_candidate'

describe Recruiter::GithubCandidate do
  let(:client) { Recruiter::API.build_client(configuration: { access_token: ENV.fetch("GITHUB_ACCESS_TOKEN") } ) }
  let(:github_data) { double("github_user_data", login: "guiman") }
  subject { Recruiter::GithubCandidate.new(github_data, client) }

  describe "#contributions" do
    it "returns a list of all the organizations and the contributions" do
      contribution = {
        :name=>"laplatarb/focacha",
        :popularity=>2,
        :main_language=>"Ruby",
        :languages=>["Ruby", "JavaScript"],
        :contributions=>3
      }

      expect(subject.contributions).to be_a(Hash)
      expect(subject.contributions.fetch("laplatarb")).to be_an(Array)
      expect(subject.contributions.fetch("laplatarb").first).to eq(contribution)
    end
  end

  describe "#languages_2" do
    it "returns a list of all the languages" do
      repositories = subject.repositories
      repositories.concat subject.repositories_contributed
      expect(subject.languages_2(repositories)).to be_a(Hash)
      expect(subject.languages_2(repositories).fetch(:analyzed_file_count)).to eq(263)
      expect(subject.languages_2(repositories).fetch(:languages_breakdown).fetch("Ruby")).to eq(128)
    end
  end

  describe "#languages" do
    it "returns a list of all the languages" do
      ruby_repositories = [
        {:name=>"guiman/api-presenter", :languages=>["Ruby"], :popularity=>0, :main_language=>"Ruby"},
        {:name=>"guiman/baku", :languages=>["JavaScript", "Ruby"], :popularity=>2, :main_language=>"JavaScript"},
        {:name=>"guiman/build_me_an_api", :languages=>["Ruby"], :popularity=>1, :main_language=>"Ruby"},
        {:name=>"guiman/discounter", :languages=>["Ruby"], :popularity=>0, :main_language=>"Ruby"},
        {:name=>"guiman/pivotaltracker", :languages=>["Ruby"], :popularity=>0, :main_language=>"Ruby"},
        {:name=>"guiman/pivotaltracker_sprint_report", :languages=>["Ruby", "HTML"], :popularity=>0, :main_language=>"Ruby"},
        {:name=>"guiman/simply_paginate", :languages=>["Ruby"], :popularity=>4, :main_language=>"Ruby"},
        {:name=>"guiman/sinatra_realtime_chat", :languages=>["Ruby", "JavaScript", "CSS"], :popularity=>4, :main_language=>"Ruby"}
      ]

      expect(subject.languages).to be_a(Hash)
      expect(subject.languages.fetch("Ruby")).to match_array(ruby_repositories)
    end
  end

  describe "#repositories_contributed" do
    it "returns a collection of activity hashes" do
      expect(subject.repositories_contributed).to be_an(Array)
      expect(subject.repositories_contributed.first.full_name).to eq("laplatarb/focacha")
    end
  end


  describe "#parsed_activity" do
    it "returns a collection of activity hashes" do
      activity_event = {
        :created_at => "2015-05-31 10:03:37 UTC",
        :event_type => "WatchEvent",
        :main_language => nil,
        :popularity => nil,
        :repository => nil,
        :updated_at => "2015-05-31 10:03:37 UTC"
      }
      expect(subject.parsed_activity).to be_an(Array)
      expect(subject.parsed_activity.first).to eq(activity_event)
    end
  end
end
