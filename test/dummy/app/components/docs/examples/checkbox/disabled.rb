# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Disabled < Phlex::HTML
        def view_template
          div(class: "pk-checkbox-row", style: "opacity: .6") do
            render PhlexKit::Checkbox.new(id: "toggle-checkbox-disabled", name: "toggle-checkbox-disabled", disabled: true)
            render PhlexKit::Label.new(for: "toggle-checkbox-disabled") { "Enable notifications" }
          end
        end
      end
    end
  end
end
