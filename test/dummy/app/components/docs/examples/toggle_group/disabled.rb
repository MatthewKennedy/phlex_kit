# frozen_string_literal: true

module Docs
  module Examples
    module ToggleGroup
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::ToggleGroup.new(type: :multiple, variant: :outline, disabled: true) do |group|
            group.ToggleGroupItem(value: "bold") { "Bold" }
            group.ToggleGroupItem(value: "italic") { "Italic" }
            group.ToggleGroupItem(value: "underline") { "Underline" }
          end
        end
      end
    end
  end
end
