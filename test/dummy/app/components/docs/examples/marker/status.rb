# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class Status < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Marker.new(role: "status") do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Spinner.new(size: :sm) }
              render PhlexKit::MarkerContent.new { "Compacting conversation" }
            end
            render PhlexKit::Marker.new(variant: :separator, role: "status") do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Spinner.new(size: :sm) }
              render PhlexKit::MarkerContent.new { "Running tests" }
            end
          end
        end
      end
    end
  end
end
