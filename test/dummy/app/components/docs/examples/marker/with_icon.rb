# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class WithIcon < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 3rem; padding: 2rem 0;") do
            render PhlexKit::Marker.new do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Icon.new(:code, size: nil) }
              render PhlexKit::MarkerContent.new { "Switched to a new branch" }
            end
            render PhlexKit::Marker.new(variant: :separator) do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Icon.new(:search, size: nil) }
              render PhlexKit::MarkerContent.new { "Explored 4 files" }
            end
            render PhlexKit::Marker.new(style: "flex-direction: column") do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Icon.new(:circle_check, size: nil) }
              render PhlexKit::MarkerContent.new { "Syncing completed" }
            end
          end
        end
      end
    end
  end
end
