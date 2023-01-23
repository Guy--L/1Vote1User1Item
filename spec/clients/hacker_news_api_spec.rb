require 'rails_helper'
require 'faraday'

# ChatGPT conversation started with README project description
# Then it was asked to specify this test suite

RSpec.describe "Hacker News API", type: :feature do
  before(:each) do
    @conn = Faraday.new(url: "https://hacker-news.firebaseio.com/v0/") do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  feature "List of top stories" do
    scenario "API returns a list of top story IDs" do
      response = @conn.get("topstories.json")
      expect(response.status).to eq(200)
      expect(response.body).to be_an(Array)
      expect(response.body.first).to be_a(Integer)
    end
  end

  feature "Show story details" do
    scenario "API returns the details of a specific story" do
      top_story_id = @conn.get("topstories.json").body.first
      response = @conn.get("item/#{top_story_id}.json")
      expect(response.status).to eq(200)
      expect(response.body).to be_a(Hash)
      expect(response.body["title"]).to be_a(String)
    end
  end
end
