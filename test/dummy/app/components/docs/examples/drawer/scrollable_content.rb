# frozen_string_literal: true

module Docs
  module Examples
    module Drawer
      class ScrollableContent < Phlex::HTML
        def view_template
          render PhlexKit::Drawer.new do
            render PhlexKit::DrawerTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Scrollable Content" }
            end
            render PhlexKit::DrawerContent.new(side: :right) do
              render PhlexKit::DrawerHeader.new do
                render PhlexKit::DrawerTitle.new { "Move Goal" }
                render PhlexKit::DrawerDescription.new { "Set your daily activity goal." }
              end
              div(style: "overflow-y: auto; padding: 0 1rem; scrollbar-width: none;") do
                10.times do
                  p(style: "margin: 0 0 1rem; line-height: 1.5;") { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." }
                end
              end
              render PhlexKit::DrawerFooter.new do
                render PhlexKit::Button.new { "Submit" }
                render PhlexKit::DrawerClose.new do
                  render PhlexKit::Button.new(variant: :outline) { "Cancel" }
                end
              end
            end
          end
        end
      end
    end
  end
end
