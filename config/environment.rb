# Load the Rails application.

require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:time] = "%H:%M"
Time::DATE_FORMATS[:date] = "%d %b %Y"
Time::DATE_FORMATS[:date_time] = "%d %b %Y, %H:%M"
