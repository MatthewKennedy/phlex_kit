# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class BlockStart < Phlex::HTML
        def view_template
          div(class: "stack w-sm") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(id: "block-start-input", placeholder: "Enter your name")
              render PhlexKit::InputGroupAddon.new(align: :block_start) do
                render PhlexKit::InputGroupText.new { "Full Name" }
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Textarea.new(id: "block-start-textarea", placeholder: "console.log('Hello, world!');", style: "font-family: var(--pk-font-mono); font-size: .875rem;")
              render PhlexKit::InputGroupAddon.new(align: :block_start, class: "bordered") do
                render PhlexKit::Icon.new(:code, size: nil)
                render PhlexKit::InputGroupText.new(style: "font-family: var(--pk-font-mono)") { "script.js" }
                render PhlexKit::InputGroupButton.new(icon: true, style: "margin-left: auto", aria: { label: "Copy" }) do
                  render PhlexKit::Icon.new(:copy, size: nil)
                end
              end
            end
          end
        end
      end
    end
  end
end
