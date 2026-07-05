# frozen_string_literal: true

module Docs
  module Examples
    module Kbd
      class InInputGroup < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 20rem;") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Search...")
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::Icon.new(:search, size: nil)
              end
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::Kbd.new { "⌘" }
                render PhlexKit::Kbd.new { "K" }
              end
            end
          end
        end
      end
    end
  end
end
