source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

gem 'acts_as_votable'
gem 'byebug', platforms: [:mri, :mingw, :x64_mingw], group: [:development, :test]
gem 'capybara', group: [:development, :test]
gem 'coffee-rails'
gem 'devise'
gem 'jbuilder'
gem 'listen', group: :development
gem 'pg'
gem 'pry-rails'
gem 'puma'
gem 'rails', '~> 7.0.3'
gem 'redis'
gem 'rspec-rails'
gem 'bootstrap'
gem 'sassc-rails'
gem 'selenium-webdriver', group: [:development, :test]
gem 'spring', group: :development
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "bootsnap", require: false
gem 'uglifier'
gem 'web-console', group: :development
gem 'httparty'

group :development, :test do
  gem "dotenv-rails", "~> 2.1", ">= 2.1.1"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "standardrb", "~> 1.0.1"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails", "~> 6.1"
  gem "faker"
  gem "shoulda-matchers", "~> 4.5", ">= 4.5.1"
  gem "webmock"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem 'importmap-rails'
gem 'stimulus-rails'
gem "turbo-rails", "~> 1.3"
gem 'pagy', '~> 6.0' 