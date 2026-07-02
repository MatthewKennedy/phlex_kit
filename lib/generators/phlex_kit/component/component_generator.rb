# frozen_string_literal: true

require "rails/generators/named_base"

module PhlexKit
  module Generators
    # `rails g phlex_kit:component button` — the shadcn-style "eject": copies a
    # component's folder (.rb parts + co-located .css) out of the gem and into the
    # host app so the team owns and can edit the source. Appends its @import to
    # application.css. The ejected copy keeps the PhlexKit namespace; the host's
    # copy shadows the gem's via Zeitwerk load-path order.
    class ComponentGenerator < Rails::Generators::NamedBase
      source_root PhlexKit::Engine.root.join("app/components/phlex_kit").to_s

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

      def remind_collapse
        say <<~MSG
          Ejected phlex_kit/#{file_name}. Ensure your app collapses ejected
          component folders (config/application.rb):

              Rails.autoloaders.main.collapse("app/components/phlex_kit/*")

        MSG
      end
    end
  end
end
