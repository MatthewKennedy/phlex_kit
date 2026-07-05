# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class LinksAndButtons < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Marker.new(href: "#links-and-buttons") do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Icon.new(:code, size: nil) }
              render PhlexKit::MarkerContent.new { "View the pull request" }
            end
            render PhlexKit::Marker.new(as: :button) do
              render PhlexKit::MarkerIcon.new { render PhlexKit::Icon.new(:refresh, size: nil) }
              render PhlexKit::MarkerContent.new { "Revert this change" }
            end
          end
        end
      end
    end
  end
end
