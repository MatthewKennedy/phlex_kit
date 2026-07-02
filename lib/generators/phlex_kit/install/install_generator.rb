# frozen_string_literal: true

require "rails/generators/base"

module PhlexKit
  module Generators
    # `rails g phlex_kit:install` — wires PhlexKit into a host app:
    #   - drops an initializer,
    #   - adds the manifest @import to application.css (url() form),
    #   - prints the Stimulus registration snippet.
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      IMPORT_LINE = %(@import url("phlex_kit/phlex_kit.css");\n)

      def create_initializer
        template "phlex_kit.rb", "config/initializers/phlex_kit.rb"
      end

      def add_stylesheet_import
        css = "app/assets/stylesheets/application.css"
        unless File.exist?(css)
          say_status :skip, "#{css} not found — add `#{IMPORT_LINE.strip}` to your main stylesheet", :yellow
          return
        end
        if File.read(css).include?("phlex_kit/phlex_kit.css")
          say_status :identical, css, :blue
        else
          # @import must precede every rule, so prepend it.
          prepend_to_file css, IMPORT_LINE
        end
      end

      def print_stimulus_instructions
        say <<~MSG

          PhlexKit installed. To enable the interactive components (Dialog,
          Dropdown, Select, Avatar), register the Stimulus controllers:

              import { registerPhlexKitControllers } from "phlex_kit/controllers"
              registerPhlexKitControllers(application)

          Render a component anywhere a Phlex view is allowed:

              render PhlexKit::Button.new(variant: :primary) { "Save" }

        MSG
      end
    end
  end
end
