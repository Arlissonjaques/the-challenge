source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.6"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # Step-by-step debugging and stack navigation in Pry. Read more: https://github.com/deivid-rodriguez/pry-byebug
  gem 'pry-byebug'
  # RSpec for Rails 5+. Read more: https://github.com/rspec/rspec-rails
  gem 'rspec-rails', '~> 6.0.0'
  # Simple one-liner tests for common Rails functionality. Read more: https://github.com/thoughtbot/shoulda-matchers
  gem 'shoulda-matchers', '~> 5.0'
  # Annotate Rails classes with schema and routes info. Read more: https://github.com/ctran/annotate_models
  gem 'annotate'
  # A Ruby code quality reporter. Read more: https://github.com/whitesmith/rubycritic
  gem 'rubycritic', require: false
  # Code coverage for Ruby with a powerful configuration library. Read more: https://github.com/simplecov-ruby/simplecov
  gem 'simplecov', require: false
  # factories. Read more: https://github.com/thoughtbot/factory_bot_rails
  gem 'factory_bot_rails'
  # A library for generating fake data such as names, addresses, and phone numbers. Read more: https://github.com/faker-ruby/faker
  gem 'faker'
  # Strategies for cleaning databases using ActiveRecord. Read more: https://github.com/DatabaseCleaner/database_cleaner-active_record
  gem 'database_cleaner-active_record'
end

group :development do

end
