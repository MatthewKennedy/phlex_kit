# frozen_string_literal: true

module Docs
  module Examples
    module NativeSelect
      class Disabled < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::NativeSelect.new(name: "ns-disabled", disabled: true, aria: { label: "Select a fruit" }) do
              render PhlexKit::NativeSelectOption.new(value: "apple") { "Apple" }
              render PhlexKit::NativeSelectOption.new(value: "banana") { "Banana" }
            end
          end
        end
      end
    end
  end
end
