# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class WithIcon < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Item.new(variant: :outline) do
              render PhlexKit::ItemMedia.new(variant: :icon) do
                render PhlexKit::Icon.new(:shield, size: nil)
              end
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "Security Alert" }
                render PhlexKit::ItemDescription.new { "New login detected from unknown device." }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::Button.new(size: :sm, variant: :outline) { "Review" }
              end
            end
          end
        end
      end
    end
  end
end
