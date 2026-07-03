# frozen_string_literal: true

module Docs
  module Examples
    module Shimmer
      class WithMarker < Phlex::HTML
        def view_template
          div(class: "stack") do
            render PhlexKit::Marker.new(role: "status") do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Spinner.new(size: :sm) }
              render PhlexKit::MarkerContent.new(class: "pk-shimmer") { "Thinking…" }
            end
            render PhlexKit::Marker.new do
              render PhlexKit::MarkerIcon.new { "✓" }
              render PhlexKit::MarkerContent.new { "Reading 4 files" }
            end
          end
        end
      end
    end
  end
end
