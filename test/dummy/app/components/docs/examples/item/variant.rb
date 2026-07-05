# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Variant < Phlex::HTML
        ROWS = [
          [ :default, "Default Variant", "Transparent background with no border." ],
          [ :outline, "Outline Variant", "Outlined style with a visible border." ],
          [ :muted, "Muted Variant", "Muted background for secondary content." ]
        ].freeze

        def view_template
          div(class: "stack w-md", style: "gap: 1.5rem") do
            ROWS.each do |variant, title, description|
              render PhlexKit::Item.new(variant: variant) do
                render PhlexKit::ItemMedia.new(variant: :icon) do
                  render PhlexKit::Icon.new(:mail, size: nil)
                end
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { title }
                  render PhlexKit::ItemDescription.new { description }
                end
              end
            end
          end
        end
      end
    end
  end
end
