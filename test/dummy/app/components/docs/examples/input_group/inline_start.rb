# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class InlineStart < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(id: "inline-start-input", placeholder: "Search...")
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::Icon.new(:search, size: nil)
              end
            end
          end
        end
      end
    end
  end
end
