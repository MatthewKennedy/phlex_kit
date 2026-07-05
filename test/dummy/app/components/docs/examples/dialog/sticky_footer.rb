# frozen_string_literal: true

module Docs
  module Examples
    module Dialog
      class StickyFooter < Phlex::HTML
        def view_template
          render PhlexKit::Dialog.new do
            render PhlexKit::DialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Sticky Footer" }
            end
            render PhlexKit::DialogContent.new do
              render PhlexKit::DialogHeader.new do
                render PhlexKit::DialogTitle.new { "Sticky Footer" }
                render PhlexKit::DialogDescription.new { "This dialog has a sticky footer that stays visible while the content scrolls." }
              end
              div(style: "margin: 0 -1rem; padding: 0 1rem; max-height: 50vh; overflow-y: auto; scrollbar-width: none;") do
                10.times do
                  p(style: "margin: 0 0 1rem; line-height: 1.5;") { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." }
                end
              end
              render PhlexKit::DialogFooter.new do
                render PhlexKit::DialogClose.new do
                  render PhlexKit::Button.new(variant: :outline) { "Close" }
                end
              end
            end
          end
        end
      end
    end
  end
end
