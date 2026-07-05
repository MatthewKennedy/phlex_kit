# frozen_string_literal: true

module Docs
  module Examples
    module Popover
      class WithForm < Phlex::HTML
        def view_template
          render PhlexKit::Popover.new do
            render PhlexKit::PopoverTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open Popover" }
            end
            render PhlexKit::PopoverContent.new(style: "width: 16rem") do
              render PhlexKit::PopoverHeader.new do
                render PhlexKit::PopoverTitle.new { "Dimensions" }
                render PhlexKit::PopoverDescription.new { "Set the dimensions for the layer." }
              end
              div(class: "stack", style: "gap: 1rem") do
                div(class: "row") do
                  render PhlexKit::Label.new(for: "pop-width", style: "width: 50%") { "Width" }
                  render PhlexKit::Input.new(id: "pop-width", value: "100%")
                end
                div(class: "row") do
                  render PhlexKit::Label.new(for: "pop-height", style: "width: 50%") { "Height" }
                  render PhlexKit::Input.new(id: "pop-height", value: "25px")
                end
              end
            end
          end
        end
      end
    end
  end
end
