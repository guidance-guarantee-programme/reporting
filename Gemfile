source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'blazer', github: 'guidance-guarantee-programme/blazer', branch: 'export-smart-column-map'
gem 'bootstrap-kaminari-views'
gem 'bugsnag'
gem 'faraday_middleware'
gem 'foreman'
gem 'gds-sso'
gem 'google-api-client'
gem 'govuk_admin_template'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg', '~> 0.15'
gem 'puma'
gem 'rails', '5.1.2'
gem 'rubyXL'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'turbolinks'
gem 'twilio-ruby', '~> 4.13'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'overcommit', require: false
  gem 'rubocop', '0.46', require: false
  gem 'scss-lint'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'site_prism', '~> 2.12'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :production do
  gem 'rails_12factor'
end
