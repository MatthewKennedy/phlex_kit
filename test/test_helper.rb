# frozen_string_literal: true

require "minitest/autorun"
require "date" # Phlex's attribute type-dispatch references Date; Rails loads it, standalone doesn't
# ActiveSupport must load before phlex-rails (which references
# ActiveSupport::SafeBuffer at require time). In a Rails app this is already
# loaded; the standalone unit suite loads it explicitly.
require "active_support"
require "active_support/core_ext/string/output_safety"
require "phlex"
require "phlex-rails"
require "phlex_kit"

# In a Rails app the components autoload via Zeitwerk (engine collapse). For the
# plain unit suite we require them directly — each file is `module PhlexKit; class
# X < BaseComponent`, so load order doesn't matter (cross-refs are render-time).
Dir[File.expand_path("../app/components/phlex_kit/**/*.rb", __dir__)].sort.each do |f|
  require f
end

module RenderHelper
  # Render a Phlex component to an HTML string without booting a full Rails app.
  def render(component)
    component.call
  end
end
