# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class Shimmer < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Marker.new(role: "status") do
              render PhlexKit::MarkerContent.new(class: "pk-shimmer") { "Thinking..." }
            end
            render PhlexKit::Marker.new(variant: :separator, role: "status") do
              render PhlexKit::MarkerContent.new(class: "pk-shimmer") { "Reading 4 files" }
            end
          end
        end
      end
    end
  end
end
