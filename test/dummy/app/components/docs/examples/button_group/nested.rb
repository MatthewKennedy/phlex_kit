# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Nested < Phlex::HTML
        def view_template
          # Nested groups separate with a gap and stay independently rounded.
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::ButtonGroup.new do
              render PhlexKit::Button.new(variant: :outline, icon: true) do
                render PhlexKit::Icon.new(:plus, size: nil)
              end
            end
            render PhlexKit::ButtonGroup.new do
              render PhlexKit::InputGroup.new do
                render PhlexKit::Input.new(placeholder: "Send a message...")
                render PhlexKit::InputGroupAddon.new(align: :end) do
                  render PhlexKit::Icon.new(:mic, size: nil)
                end
              end
            end
          end
        end
      end
    end
  end
end
