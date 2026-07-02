# frozen_string_literal: true

module Docs
  module Examples
    module Popover
      class Dimensions < Phlex::HTML
        def view_template
          render PhlexKit::Popover.new do
            render PhlexKit::PopoverTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open popover" }
            end
            render PhlexKit::PopoverContent.new do
              div(class: "stack", style: "width:16rem") do
                strong { "Dimensions" }
                span(style: "font-size:.875rem;color:var(--pk-muted)") { "Set the dimensions for the layer." }
                render PhlexKit::FormField.new do
                  render PhlexKit::FormFieldLabel.new(for: "pop-width") { "Width" }
                  render PhlexKit::Input.new(id: "pop-width", value: "100%")
                end
              end
            end
          end
        end
      end
    end
  end
end
