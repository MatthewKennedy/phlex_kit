# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class WithButton < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1.5rem") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(value: "https://x.com/shadcn", readonly: true)
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::InputGroupButton.new(icon: true, aria: { label: "Copy" }, title: "Copy") do
                  render PhlexKit::Icon.new(:copy, size: nil)
                end
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Type to search...")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::InputGroupButton.new(variant: :secondary) { "Search" }
              end
            end
          end
        end
      end
    end
  end
end
