source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'rails', '4.2.6'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bugsnag'
gem 'bootstrap-kaminari-views'
gem 'gds-sso'
gem 'govuk_admin_template'
gem 'foreman'
gem 'kaminari'
gem 'puma'
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'twilio-ruby'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'overcommit', require: false
  gem 'rubocop', require: false
  gem 'travis', require: false
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'pry-byebug'
end

group :production do
  gem 'rails_12factor'
end
