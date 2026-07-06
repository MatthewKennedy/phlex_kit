# frozen_string_literal: true

require "json" # Carousel serializes its options value standalone (no Rails to_json)
require "securerandom" # DatePicker generates a default input id
require "cgi" # DataTable sort/pagination build query strings standalone
# phlex-rails references ActiveSupport::SafeBuffer at require time; in a Rails
# app it's already loaded, but a bare `require "phlex_kit"` (script/console)
# crashes with "uninitialized constant Phlex::ActiveSupport" without these.
require "active_support"
require "active_support/core_ext/string/output_safety"
require "phlex"
require "phlex-rails"

require "phlex_kit/version"
require "phlex_kit/configuration"
require "phlex_kit/icons"
require "phlex_kit/base_component"

# The Rails engine (asset path, Zeitwerk collapse, Propshaft guard, JS) is only
# needed inside a Rails app. Load it when Rails is present; the components
# themselves are plain Phlex classes and work without it.
require "phlex_kit/engine" if defined?(::Rails::Engine)

module PhlexKit
  # Components live under app/components/phlex_kit and are autoloaded by the host
  # app's Zeitwerk (via the engine). Nothing else to require here.
end
