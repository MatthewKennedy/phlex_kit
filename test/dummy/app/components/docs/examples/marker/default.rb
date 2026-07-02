# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-lg") do
            render PhlexKit::Marker.new do
              render PhlexKit::MarkerIcon.new { "✓" }
              render PhlexKit::MarkerContent.new { "Explored 4 files" }
            end
            render PhlexKit::Marker.new(variant: :border) do
              render PhlexKit::MarkerIcon.new { "📄" }
              render PhlexKit::MarkerContent.new { "Opened implementation notes" }
            end
            render PhlexKit::Marker.new(variant: :separator) do
              render PhlexKit::MarkerContent.new { "Today" }
            end
          end
        end
      end
    end
  end
end
