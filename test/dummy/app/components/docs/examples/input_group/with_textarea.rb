# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class WithTextarea < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 28rem;") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Textarea.new(id: "textarea-code", placeholder: "console.log('Hello, world!');", rows: 8, style: "font-family: var(--pk-font-mono); font-size: .875rem;")
              render PhlexKit::InputGroupAddon.new(align: :block_start, class: "bordered") do
                render PhlexKit::InputGroupText.new(style: "font-family: var(--pk-font-mono); font-weight: 500;") { "script.js" }
                render PhlexKit::InputGroupButton.new(icon: true, style: "margin-left: auto", aria: { label: "Refresh" }) do
                  render PhlexKit::Icon.new(:refresh, size: nil)
                end
                render PhlexKit::InputGroupButton.new(icon: true, aria: { label: "Copy" }) do
                  render PhlexKit::Icon.new(:copy, size: nil)
                end
              end
              render PhlexKit::InputGroupAddon.new(align: :block_end, class: "bordered") do
                render PhlexKit::InputGroupText.new { "Line 1, Column 1" }
                render PhlexKit::InputGroupButton.new(variant: :primary, size: :sm, style: "margin-left: auto") { "Run" }
              end
            end
          end
        end
      end
    end
  end
end
