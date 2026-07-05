# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class WithPopover < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::Button.new(variant: :outline) { "Copilot" }
            render PhlexKit::Popover.new do
              render PhlexKit::PopoverTrigger.new do
                render PhlexKit::Button.new(variant: :outline, icon: true, aria: { label: "Open Popover" }) do
                  render PhlexKit::Icon.new(:chevron_down, size: nil)
                end
              end
              render PhlexKit::PopoverContent.new(align: :end) do
                render PhlexKit::PopoverHeader.new do
                  render PhlexKit::PopoverTitle.new { "Start a new task with Copilot" }
                  render PhlexKit::PopoverDescription.new { "Describe your task in natural language." }
                end
                render PhlexKit::Textarea.new(placeholder: "I need to...", rows: 3)
                p(style: "font-size: .75rem; color: var(--pk-muted); margin: 0;") { "Copilot will open a pull request for review." }
              end
            end
          end
        end
      end
    end
  end
end
