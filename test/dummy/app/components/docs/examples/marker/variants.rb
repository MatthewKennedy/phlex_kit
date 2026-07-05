# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class Variants < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Marker.new do
              render PhlexKit::MarkerContent.new { "A default marker for inline notes." }
            end
            render PhlexKit::Marker.new(variant: :separator) do
              render PhlexKit::MarkerContent.new { "A separator marker" }
            end
            render PhlexKit::Marker.new(variant: :border) do
              render PhlexKit::MarkerContent.new { "A border marker for row boundaries." }
            end
          end
        end
      end
    end
  end
end
