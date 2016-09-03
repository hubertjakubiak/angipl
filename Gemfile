source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3'
end
group :production do
  gem 'pg', '~> 0.18.4'
end
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


gem 'haml', '~> 4.0.5'
gem "haml-rails", "~> 0.9"
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
gem 'devise'
gem 'simple_form'
gem 'jquery-turbolinks'
gem 'active_link_to'
gem 'commontator', '~> 4.11.1'
gem 'devise-i18n'
gem 'acts_as_votable', '~> 0.10.0'
gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate-bootstrap'
gem 'rails_admin'
gem 'cancancan', '~> 1.10'
gem "paperclip", "~> 5.0.0"
gem 'draper', '~> 2.1'
gem 'decent_exposure', '~> 2.3', '>= 2.3.3'
gem 'decent_decoration', '~> 0.0.6'
gem 'faker', '~> 1.6', '>= 1.6.3'

group :development, :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'spring'
  gem 'web-console', '~> 2.0'
  gem "better_errors"
  gem 'capybara'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.1'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false
end