# frozen_string_literal: true

module Docs
  module Examples
    module Sheet
      # Escape-layering fixture (audit round 9, phase 2): a popover=manual
      # DropdownMenu opened from inside a SheetContent panel. The menu's own
      # document-level Escape handler owns the first Escape (closing just the
      # menu); a second Escape then closes the sheet underneath, rather than
      # the sheet's element-scoped keydown closing both at once.
      class WithNestedMenu < Phlex::HTML
        def view_template
          render PhlexKit::Sheet.new do
            render PhlexKit::SheetTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::SheetContent.new do
              render PhlexKit::SheetHeader.new do
                render PhlexKit::SheetTitle.new { "Sheet with nested menu" }
                render PhlexKit::SheetDescription.new { "A menu lives inside this sheet." }
              end
              render PhlexKit::DropdownMenu.new do
                render PhlexKit::DropdownMenuTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { "Open menu" }
                end
                render PhlexKit::DropdownMenuContent.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "One" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Two" }
                end
              end
            end
          end
        end
      end
    end
  end
end
