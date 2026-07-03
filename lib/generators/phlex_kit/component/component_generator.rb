# frozen_string_literal: true

require "rails/generators/named_base"

module PhlexKit
  module Generators
    # `rails g phlex_kit:component button` — the shadcn-style "eject": copies a
    # component's folder (.rb parts + co-located .css + _controller.js) out of the
    # gem and into the host app so the team owns and can edit the source. Appends
    # its @import to application.css and wires config/application.rb (once) so the
    # ejected copy fully shadows the gem's — Ruby, CSS, and JS alike.
    class ComponentGenerator < Rails::Generators::NamedBase
      source_root PhlexKit::Engine.root.join("app/components/phlex_kit").to_s

      # Marker that `wire_host_app` is idempotent against — presence means an
      # earlier eject already wired config/application.rb.
      COLLAPSE_LINE = %(Rails.autoloaders.main.collapse(Rails.root.join("app/components/phlex_kit/*")))

      def eject_component
        unless File.directory?(File.join(self.class.source_root, file_name))
          say_status :error, "no PhlexKit component named '#{file_name}'", :red
          return
        end
        directory file_name, "app/components/phlex_kit/#{file_name}"
      end

      def wire_import
        css = "app/assets/stylesheets/application.css"
        line = %(@import url("phlex_kit/#{file_name}/#{file_name}.css");\n)
        return unless File.exist?(css)
        prepend_to_file(css, line) unless File.read(css).include?(line.strip)
      end

      # Make an ejected component fully editable, in one step. Two things are
      # needed and neither is on by default in a host app:
      #   1. Zeitwerk collapse — so app/components/phlex_kit/button/button.rb
      #      autoloads as PhlexKit::Button (not ::Button::Button). Fixes Ruby.
      #   2. Host app/components ahead of the gem on Propshaft's asset path — so
      #      the ejected <name>.css and <name>_controller.js resolve to the host
      #      copy instead of the gem's. Without this the Ruby shadows but the CSS
      #      and JS silently keep serving the gem's originals.
      # Injected once (idempotent) right after config.load_defaults, where
      # config.assets is available.
      def wire_host_app
        app_rb = "config/application.rb"
        unless File.exist?(app_rb)
          say_status :skip, "#{app_rb} not found — wire ejected components manually (see docs/05-PROPSHAFT-INSTALL.md)", :yellow
          return
        end
        if File.read(app_rb).include?(COLLAPSE_LINE)
          say_status :identical, "#{app_rb} already wired for ejected components", :blue
          return
        end
        inject_into_file app_rb, after: /^\s*config\.load_defaults.*\n/ do
          # Indent only non-empty lines so the blank separator carries no trailing space.
          <<~RUBY.gsub(/^(?=.)/, "    ")

            # PhlexKit: make ejected components under app/components/phlex_kit/
            # fully editable — collapse so <name>/<name>.rb autoloads as
            # PhlexKit::<Name>, and put the dir ahead of the gem on the asset path
            # so the ejected <name>.css and <name>_controller.js shadow the gem's.
            #{COLLAPSE_LINE}
            config.assets.paths.unshift(Rails.root.join("app/components"))
          RUBY
        end
      end

      def confirm
        say_status :phlex_kit, "ejected phlex_kit/#{file_name} — your copy now shadows the gem (Ruby, CSS, JS)", :green
      end
    end
  end
end
