# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class WithInput < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::ButtonGroup.new do
              render PhlexKit::Input.new(placeholder: "Search...")
              render PhlexKit::Button.new(variant: :outline, aria: { label: "Search" }) do
                render PhlexKit::Icon.new(:search, size: nil)
              end
            end
          end
        end
      end
    end
  end
end
