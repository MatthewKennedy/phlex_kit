# frozen_string_literal: true

module Docs
  module Examples
    module NativeSelect
      class Default < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::NativeSelect.new(name: "store") do
              render PhlexKit::NativeSelectOption.new(value: "") { "All stores" }
              render PhlexKit::NativeSelectGroup.new(label: "Live") do
                render PhlexKit::NativeSelectOption.new(value: "tkf") { "Tongkat Fitness" }
                render PhlexKit::NativeSelectOption.new(value: "sts") { "Sole Trader Support" }
              end
            end
          end
        end
      end
    end
  end
end
