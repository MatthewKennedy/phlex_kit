# frozen_string_literal: true

module Docs
  module Examples
    module Dialog
      class NoCloseButton < Phlex::HTML
        def view_template
          render PhlexKit::Dialog.new do
            render PhlexKit::DialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "No Close Button" }
            end
            # Escape (native <dialog>) and the backdrop still dismiss it.
            render PhlexKit::DialogContent.new(show_close_button: false) do
              render PhlexKit::DialogHeader.new do
                render PhlexKit::DialogTitle.new { "No Close Button" }
                render PhlexKit::DialogDescription.new { "This dialog doesn't have a close button in the top-right corner." }
              end
            end
          end
        end
      end
    end
  end
end
