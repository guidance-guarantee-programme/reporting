source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'azure-storage-blob'
gem 'bigdecimal'
gem 'blazer', github: 'guidance-guarantee-programme/blazer', branch: 'export-smart-column-map'
gem 'bootstrap-kaminari-views'
gem 'bugsnag'
gem 'faraday_middleware'
gem 'foreman'
gem 'gds-sso'
gem 'google-api-client'
gem 'govuk_admin_template'
gem 'handlebars_assets'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg'
gem 'postgres-copy'
gem 'puma'
gem 'rails', '~> 6.0'
gem 'rubyXL'
gem 'sassc-rails'
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'turbolinks'
gem 'twilio-ruby', '~> 4.13'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'overcommit', require: false
  gem 'rubocop', '0.46', require: false
  gem 'scss_lint'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec'
  gem 'rspec-rails'
end

group :production do
  gem 'rails_12factor'
end
