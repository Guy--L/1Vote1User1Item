namespace :hacker_news do
  desc "Retrieve news items from Hacker News"
  task retrieve: :environment do
    NewsClient.new.news_update
  end
end
