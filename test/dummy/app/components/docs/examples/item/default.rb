# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Default < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::ItemGroup.new do
              render PhlexKit::Item.new(variant: :outline) do
                render PhlexKit::ItemMedia.new { "📦" }
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { "Basic Item" }
                  render PhlexKit::ItemDescription.new { "A simple item with title and description." }
                end
                render PhlexKit::ItemActions.new do
                  render PhlexKit::Button.new(size: :sm, variant: :outline) { "Action" }
                end
              end
              render PhlexKit::Item.new(variant: :muted) do
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { "Muted variant" }
                end
              end
            end
          end
        end
      end
    end
  end
end
