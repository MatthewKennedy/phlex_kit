# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class InlineEnd < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(id: "inline-end-input", type: :password, placeholder: "Enter password")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::Icon.new(:eye_off, size: nil)
              end
            end
          end
        end
      end
    end
  end
end
