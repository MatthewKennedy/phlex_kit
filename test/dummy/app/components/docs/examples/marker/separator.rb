# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class Separator < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Marker.new(variant: :separator) do
              render PhlexKit::MarkerContent.new { "Yesterday" }
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
