require 'rails_helper'
require 'selenium-webdriver'

logs = []
RSpec.describe "Server Push", type: :system do
    before do
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

        def take_failed_screenshot
            false
        end        
    end
    
    context 'when adding new items' do
        it 'see new items on first page in retrieval order', js: true do
            user = create(:user)
            other = create(:user)
            items = create_list(:item, 25)

            sign_in(user)

            visit root_path

            within('.pagination') do
                expect(page).to have_content '2'
                expect(page).to have_no_content '3'
            end
            
            newitems = create_list(:item, 5)
            
            expect(page).to have_no_content(items[4].title)
            expect(page).to have_content(items[5].title)
            expect(page).to have_content(items[15].title)
            expect(page).to have_content(newitems[0].title)

            using_session("other") do
                sign_in(other)

                visit root_path

                expect(page).to have_no_content(items[4].title)
                # expect(page).to have_content(items[5].title)
                expect(page).to have_content(items[15].title)
                    
                expect(page).to have_content(newitems[0].title)
                expect(page).to have_content(newitems[4].title)
            end

            # expect(page).to have_content newitems[1].title, wait: 30
            # expect(page).to have_content newitems[4].title, wait: 40
            
        end

        xit 'see new items on second page in vote count order', js: true do
            user = create(:user)
            items = create_list(:item, 22, :carrying_votes)
            moreitems = create_list(:item, 3)

            sign_in(user)

            visit root_path
            expect(page).to have_content(items[0].title)
            expect(page).to have_content(items[19].title)

            click_link 'Sort by Votes'

            expect(page).to have_content('Sort by Retrieval')

            sleep 10

            click_link 'Next'

            sleep 10

            within('.pagination') do
                expect(page).to have_content '2'
                expect(page).to have_no_content '3'
                # expect(page.find('div.container li.active')).to have_selector(:link, '', href: '/?page=2')
            end
            
            expect(page).to have_no_content(items[19].title)
            expect(page).to have_content(items[20].title, wait: 5)
            expect(page).to have_content(moreitems[0].title)
            expect(page).to have_content(moreitems[2].title)

            newitems = create_list(:item, 5)
            
            expect(page).to have_content(newitems[0].title)

            # using_session("other") do
            #     sign_in(other)

            #     visit root_path

            #     expect(page).to have_no_content(items[4].title)
            #     # expect(page).to have_content(items[5].title)
            #     expect(page).to have_content(items[15].title)
                    
            #     expect(page).to have_content(newitems[0].title)
            #     expect(page).to have_content(newitems[4].title)
            # end

            # # expect(page).to have_content newitems[1].title, wait: 30
            # # expect(page).to have_content newitems[4].title, wait: 40
            
        end


    end

    context 'when voting' do
        it 'allows user to vote, rescind vote and concurrent other users to see that vote' do
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
    end

    after do
        Capybara.current_session.quit
    end
end