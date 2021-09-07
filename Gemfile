source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem 'rails', '~> 6.1.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'active_model_serializers', '~> 0.10.12'
gem 'bcrypt', '~> 3.1', '>= 3.1.16'
gem 'jwt', '~> 2.2', '>= 2.2.3'
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem 'sidekiq', '~> 6.2', '>= 6.2.2'

group :development, :test do
  gem 'awesome_print', '~> 1.9', '>= 1.9.2'
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.18'
  gem 'rspec-rails', '~> 5.0.0'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
