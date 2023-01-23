require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Topnews
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_record.legacy_connection_handling = false
    # config.action_controller.silence_disabled_session_errors = true
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.after_initialize do
      if(!Rails.env.test?)
        Rails.application.load_tasks # <---
        Rake::Task['hacker_news:retrieve'].invoke
      end
    end
  end
end
