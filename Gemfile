source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.2"

gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'kaminari'

gem 'interactor', '~> 3.0'
gem 'interactor-contracts'

gem 'paper_trail', '>= 11.1.0'

gem 'aws-sdk-s3'

gem 'config'
gem 'zero-rails_openapi'

gem 'actionpack-action_caching'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'whenever'

gem 'bcrypt', '~> 3.1.7'

gem "net-http"

gem 'jwt'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'airborne'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'cpf_faker'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker', '>= 2.13.0'
  gem 'rspec-rails', '~> 4.0.2'
  gem 'shoulda-matchers', '>= 4.3.0'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

