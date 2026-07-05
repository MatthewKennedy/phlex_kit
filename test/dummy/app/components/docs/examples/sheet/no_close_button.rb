# frozen_string_literal: true

module Docs
  module Examples
    module Sheet
      class NoCloseButton < Phlex::HTML
        def view_template
          render PhlexKit::Sheet.new do
            render PhlexKit::SheetTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "No Close Button" }
            end
            # The backdrop and Escape still dismiss it.
            render PhlexKit::SheetContent.new(show_close_button: false) do
              render PhlexKit::SheetHeader.new do
                render PhlexKit::SheetTitle.new { "No Close Button" }
                render PhlexKit::SheetDescription.new { "This sheet doesn't have a close button in the top-right corner." }
              end
            end
          end
        end
      end
    end
  end
end
