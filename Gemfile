source 'https://rubygems.org'

ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',                                            '~> 4.2.2'
# Use SCSS for stylesheets
gem 'sass-rails',                                       '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',                                         '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails',                                     '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# For image processing
gem 'carrierwave',                                      '~> 0.10.0'

# For postgres database
gem 'pg',                                               '~> 0.18.2'

# For user login feature
gem 'devise',                                           '~> 3.5.1'

# For better debugging
gem 'better_errors',                                    '~> 2.1.1'

# Use jquery as the JavaScript library
gem 'jquery-rails',                                     '~> 4.0.4'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks',                                       '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder',                                         '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',                                             '~> 0.4.0', group: :doc

gem 'quiet_assets',                                     '~> 1.1.0'

gem 'pg_search',                                        '~> 1.0.4'

gem 'delayed_job_active_record',                        '~> 4.0.3'
gem 'daemons',                                          '~> 1.2.3'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug',                                         '~> 5.0.0'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console',                                    '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # [TODO - S] How does spring work? I need a session from you.
  gem 'spring',                                         '~> 1.3.6'
end

group :production do
  gem 'rails_12factor',                                 '~> 0.0.3'
end
