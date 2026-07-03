# frozen_string_literal: true

require "rails"
require "action_controller/railtie"
require "propshaft"
require "importmap-rails"
require "phlex_kit"
require "rouge" # docs-site syntax highlighting — the "host adds it" pattern

module Dummy
  # Minimal host app for eyeballing the kit: one gallery page rendering every
  # component, served with the real engine wiring (Propshaft assets, Zeitwerk
  # collapse, importmap-pinned Stimulus controllers). Boot it from the gem root:
  #
  #   bundle exec puma -p 3999 test/dummy/config.ru
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.root = File.expand_path("..", __dir__)
    config.eager_load = false
    config.secret_key_base = "phlex_kit-dummy-gallery"
    config.hosts.clear
    config.consider_all_requests_local = true
    config.server_timing = false
    config.assets.paths << Rails.root.join("app/assets/fonts") # vendored Geist for the docs site
    config.logger = Logger.new($stdout)
    config.log_level = :warn
  end
end
