source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.5'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Workinonit gems
## OAuth
gem 'omniauth' # OmniAuth for managing OAuth
gem 'omniauth-rails_csrf_protection' # version 2+ of OmniAuth requires post requests (in link to strategy) to be used by default - this gem is required in order to permit these requests (info: https://stackoverflow.com/questions/65783394/no-route-matches-get-auth-google-oauth2-error-keeps-coming-up/65785932#65785932)
gem 'omniauth-facebook' # log in via Facebook
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master' # log in via GitHub
gem 'omniauth-google-oauth2' # log in via Google
## scraping
gem 'open-uri' # for opening webpages (feeds into Nokogiri)
gem 'nokogiri' # for scraping webpages
## JQuery for additional JavaScript
gem 'jquery-rails'
## PostgreSQL for database
gem 'pg'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Workinonit gems
  gem 'pry' # open console with binding (when `binding.pry` is run)
  gem 'rails-erd' # entity relationship diagrams
  gem 'seed_dump' # create seed file from current database
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
