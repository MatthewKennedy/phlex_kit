# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class WithInput < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new(class: "w-md") do
            render PhlexKit::Input.new(placeholder: "https://phlexkit.dev")
            render PhlexKit::Button.new(variant: :outline) { "Copy" }
          end
        end
      end
    end
  end
end
