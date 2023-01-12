require 'rails_helper'

RSpec.describe "Votes", type: :system do
    before do
        driven_by(:selenium_chrome_headless)
    end
    
    it 'allows users to vote and concurrent other users to see that vote' do
        user = create(:user)
        other = create(:user)
        item = create(:item)

        sign_in(user)

        visit root_path

        click_button "apply your vote"

        expect(page).to have_content("1 vote")
        expect(page).to have_content(user.full_name).twice
        expect(page).to have_content("rescind your vote")

        using_session("other") do
            sign_in(other)

            visit root_path

            expect(page).to have_content("1 vote")
            expect(page).to have_content(other.full_name)
            expect(page).to have_content(user.full_name)
            expect(page).to have_content("apply your vote")

            click_button "apply your vote"

            expect(page).to have_content("2 votes")
            expect(page).to have_content("rescind your vote")
            expect(page).to have_content(other.full_name).twice
            expect(page).to have_content(user.full_name)
        end

        expect(page).to have_content("2 votes")

        click_button "rescind your vote"

        expect(page).to have_content("1 vote")
        expect(page).to have_content(user.full_name).once
        expect(page).to have_content("apply your vote")
    end

    after do
        Capybara.current_session.quit
    end
end