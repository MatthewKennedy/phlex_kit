# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rails", ">= 7.1", "< 9"

group :development, :test do
  gem "rubocop-rails-omakase", require: false
  gem "puma", require: false # serves the test/dummy component gallery
  gem "rouge", require: false # syntax highlighting in the test/dummy docs site (the kit itself stays plain)
end
