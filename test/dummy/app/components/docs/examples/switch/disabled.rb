# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class Disabled < Phlex::HTML
        def view_template
          div(class: "row", style: "gap: 1.5rem") do
            render PhlexKit::Switch.new(name: "sw-dis-1", disabled: true)
            render PhlexKit::Switch.new(name: "sw-dis-2", checked: true, disabled: true)
          end
        end
      end
    end
  end
end
