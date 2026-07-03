# frozen_string_literal: true

require "rails/engine"

module PhlexKit
  # Turns the four hand-wired pieces from revue (asset path, Zeitwerk collapse,
  # Propshaft source-skip, JS registration) into engine behavior every host gets
  # for free.
  class Engine < ::Rails::Engine
    # (1) Co-locate CSS beside the .rb: put the component + stylesheet dirs on
    #     Propshaft's load path so `@import url("phlex_kit/button/button.css")`
    #     and the manifest resolve and get fingerprinted.
    initializer "phlex_kit.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app/components")
        app.config.assets.paths << root.join("app/assets/stylesheets")
        # The Stimulus controllers are co-located under app/components (served via
        # the path above); this keeps the central registry (controllers/index.js)
        # servable too, or the "phlex_kit/controllers" pin from (4) resolves to a
        # missing asset and gets silently skipped.
        app.config.assets.paths << root.join("app/javascript")
      end
    end

    # (2) Collapse component folders so app/components/phlex_kit/button/button.rb
    #     autoloads as PhlexKit::Button (not PhlexKit::Button::Button), and a part
    #     like card/card_header.rb is PhlexKit::CardHeader.
    initializer "phlex_kit.zeitwerk" do
      autoloader = Rails.autoloaders.main
      autoloader.collapse(root.join("app/components/phlex_kit/*"))
    end

    # (3) Keep Propshaft from serving our Ruby source out of public/assets/.
    initializer "phlex_kit.propshaft_guard" do
      require "phlex_kit/propshaft_skip_source" if defined?(Propshaft)
    end

    # (4) Register the Stimulus controllers for interactive components when the
    #     host uses importmap-rails. Bundler users import from the gem path.
    initializer "phlex_kit.importmap", before: "importmap" do |app|
      if app.respond_to?(:config) && app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
        # Colocated controllers change under app/components; the central registry
        # lives under app/javascript. Sweep both so edits bust the importmap cache.
        app.config.importmap.cache_sweepers << root.join("app/components")
        app.config.importmap.cache_sweepers << root.join("app/javascript")
      end
    end

    # (5) Optional convenience alias so revue-style `UI::Button` keeps working.
    config.after_initialize do
      Object.const_set(:UI, PhlexKit) if PhlexKit.config.define_ui_alias && !Object.const_defined?(:UI)
    end
  end
end
