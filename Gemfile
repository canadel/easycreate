source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'



gem "devise", "~> 1.5.1"

gem 'json'

gem 'haml'
gem 'haml-rails'
gem 'kaminari'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
                              :git => 'git://github.com/anjlab/bootstrap-rails.git'
gem 'twitter_bootstrap_form_for' # https://github.com/stouset/twitter_bootstrap_form_for

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


# Deploy with Capistrano
#gem 'capistrano'

gem 'execjs'
#gem 'therubyracer'

gem 'httparty'

gem 'heroku'

group :production do
  gem 'pg'
end

group :development do
  gem 'sqlite3'
  gem 'unicorn'
  gem 'rails3-generators'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'pry'
  gem 'hpricot'
  gem 'ruby_parser'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers', :require => false
  gem 'steak'
  gem 'factory_girl_rails', '>= 1.1.0'
  gem 'forgery', '0.3.12'
  gem 'log_buddy'
end

group :test do
  # Pretty printed test output
  gem 'capybara', '>= 1.0.1'
  gem 'database_cleaner', '>= 0.6.7'
  gem 'launchy', '>= 2.0.5'
  gem 'turn', :require => false
  gem 'webmock'
  gem 'accept_values_for', git: 'https://github.com/bogdan/accept_values_for.git'
end

