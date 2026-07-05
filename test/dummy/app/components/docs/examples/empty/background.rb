# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class Background < Phlex::HTML
        def view_template
          render PhlexKit::Empty.new(class: "w-md", style: "background: color-mix(in oklab, var(--pk-surface-2) 30%, transparent)") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new(variant: :icon) do
                render PhlexKit::Icon.new(:bell, size: nil)
              end
              render PhlexKit::EmptyTitle.new { "No Notifications" }
              render PhlexKit::EmptyDescription.new(style: "max-width: 20rem") { "You're all caught up. New notifications will appear here." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new(variant: :outline) do
                render PhlexKit::Icon.new(:refresh, size: nil)
                plain "Refresh"
              end
            end
          end
        end
      end
    end
  end
end
