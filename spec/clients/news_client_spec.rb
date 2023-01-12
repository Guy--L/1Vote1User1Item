require 'rails_helper'
require 'support/client_helpers'

RSpec.configure do |c|
    c.include ClientHelpers
end

describe "NewsClient" do
    let(:an_http_double) { double("http double") }
    let(:items_new) { build_list(:item, 3) }
    let(:items_old) { create_list(:item, 4) }
    let(:api_new) { items_new.map { |i| api_item(i.as_json) } }
    let(:api_old) { items_old.map { |i| api_item(i.as_json) } }

    subject { NewsClient.new() }

    context "topstories" do
        it "should save all new stories" do
            topids = items_new.map { |i| i.item_id }

            stub_request(:get, 'https://hacker-news.firebaseio.com/v0/topstories.json')
              .to_return(status: 200, body: topids.to_json)

            api_new.length.times do |i|
                stub_request(:get, "https://hacker-news.firebaseio.com/v0/item/#{topids[i]}.json")
                  .to_return(status: 200, body: api_new[i])
            end
            expect{subject.news_update()}.to change(Item, :count).by(api_new.length)
        end

        it "should save only new stories" do
            topids = items_new.map { |i| i.item_id } + items_old.map { |i| i.item_id }

            stub_request(:get, 'https://hacker-news.firebaseio.com/v0/topstories.json')
              .to_return(status: 200, body: topids.to_json)

            api_new.length.times do |i|
                stub_request(:get, "https://hacker-news.firebaseio.com/v0/item/#{topids[i]}.json")
                  .to_return(status: 200, body: api_new[i])
            end

            api_old.length.times do |i|
                stub_request(:get, "https://hacker-news.firebaseio.com/v0/item/#{topids.drop(3)[i]}.json")
                    .to_return(status: 200, body: api_old[i])
            end
            expect(Item.count).to be(api_old.length)
            expect{subject.news_update()}.to change(Item, :count).by(api_new.length)
        end

        it "should not save old stories" do
            topids = items_old.map { |i| i.item_id }

            stub_request(:get, 'https://hacker-news.firebaseio.com/v0/topstories.json')
              .to_return(status: 200, body: topids.to_json)

            (api_old.length-1).times do |i|
                stub_request(:get, "https://hacker-news.firebaseio.com/v0/item/#{topids[i]}.json")
                  .to_return(status: 200, body: api_old[i])
            end
            expect(Item.count).to be(api_old.length)
            expect{subject.news_update()}.to change(Item, :count).by(0)
        end
    end
end
