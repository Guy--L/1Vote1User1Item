require 'rails_helper'
require 'capybara/rspec'

# ChatGPT spec from README.md file

RSpec.describe "Hacker News Team UI", type: :feature do
  before(:each) do
    @user = User.create(username: "testuser", password: "testpassword")
    visit login_path
    fill_in "username", with: "testuser"
    fill_in "password", with: "testpassword"
    click_button "Sign In"
  end

  feature "Signing in" do
    scenario "user can successfully sign in" do
      expect(page).to have_content("Welcome, testuser")
    end
  end

  feature "Viewing top stories" do
    scenario "user can see a list of current top Hacker News stories" do
      expect(page).to have_css("#top-stories-list")
    end

    scenario "list of stories is continuously updated" do
      # Assert that top stories list is updated every 5 minutes
      expect(page).to have_content("List last updated less than 5 minutes ago")
    end
  end

  feature "Voting for a story" do
    scenario "user can vote for a story" do
      within("#top-stories-list") do
        find("#story-1").find("#vote-button").click
      end
      expect(page).to have_content("Story 1 has been voted for by testuser.")
    end
  end

  feature "Viewing flagged stories" do
    scenario "user can see a list of flagged stories" do
      expect(page).to have_css("#flagged-stories-list")
    end

    scenario "flagged stories show the name of the team member who flagged it" do
      within("#flagged-stories-list") do
        expect(page).to have_content("Flagged by testuser")
      end
    end
  end
end
