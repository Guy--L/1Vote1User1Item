require 'rails_helper'

RSpec.describe "Items", type: :request do
  context 'when signed in' do
    let(:user) { create(:user) }

    before { sign_in user }

    it 'responds ok and shows login' do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(user.full_name)
    end

    it 'lists items with link to vote' do
      item = create(:item)
      get root_path
      expect(response.body).to include(item.url)
      expect(response.body).to include(item.title)
      expect(response.body).to include(item.by)
      expect(response.body).to include(vote_item_path(item))
      expect(response.body).to include('apply your vote')
    end

    it 'lists items with votes' do
      item = create(:item, :carrying_votes)

      get root_path

      expect(response.body).to include(item.voter_names)
    end

    it "marks items with logged in user's vote" do
      item = create(:item)
      item.liked_by user

      get root_path

      expect(response.body).to match(/(^rescind your vote)*#{Regexp.quote(user.full_name)}/)
    end
  end

  context 'when not signed in' do
    it 'redirects to sign in' do
      get root_path
      expect(response).to redirect_to new_user_session_path
    end

    it 'redirects to sign in after spoofing vote url' do
      item = create(:item)
      patch vote_item_path(item)
      expect(response).to redirect_to new_user_session_path
    end

    it 'redirects to sign in after spoofing refresh url' do
      put refeed_item_path(0)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
