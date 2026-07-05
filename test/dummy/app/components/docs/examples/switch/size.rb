# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class Size < Phlex::HTML
        def view_template
          div(class: "row", style: "gap: 1.5rem") do
            render PhlexKit::Switch.new(name: "sw-size-sm", size: :sm, checked: true)
            render PhlexKit::Switch.new(name: "sw-size-md", checked: true)
          end
        end
      end
    end
  end
end
