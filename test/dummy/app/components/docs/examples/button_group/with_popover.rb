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
                render PhlexKit::Field.new do
                  render PhlexKit::FieldLabel.new(for: "bg-pop-task", class: "pk-sr-only") { "Task Description" }
                  render PhlexKit::Textarea.new(id: "bg-pop-task", placeholder: "I need to...", rows: 3)
                  render PhlexKit::FieldDescription.new { "Copilot will open a pull request for review." }
                end
              end
            end
          end
        end
      end
    end
  end
end
