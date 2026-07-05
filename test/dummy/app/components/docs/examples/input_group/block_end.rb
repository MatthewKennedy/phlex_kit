# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class BlockEnd < Phlex::HTML
        def view_template
          div(class: "stack w-sm") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(id: "block-end-input", placeholder: "Enter amount")
              render PhlexKit::InputGroupAddon.new(align: :block_end) do
                render PhlexKit::InputGroupText.new { "USD" }
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Textarea.new(id: "block-end-textarea", placeholder: "Write a comment...")
              render PhlexKit::InputGroupAddon.new(align: :block_end, class: "bordered") do
                render PhlexKit::InputGroupText.new { "0/280" }
                render PhlexKit::InputGroupButton.new(variant: :primary, size: :sm, style: "margin-left: auto") { "Post" }
              end
            end
          end
        end
      end
    end
  end
end
