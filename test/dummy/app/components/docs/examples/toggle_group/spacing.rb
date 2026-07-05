# frozen_string_literal: true

module Docs
  module Examples
    module ToggleGroup
      class Spacing < Phlex::HTML
        def view_template
          # spacing: 0 (default) joins the items; > 0 separates them.
          render PhlexKit::ToggleGroup.new(type: :multiple, variant: :outline, spacing: 1) do |group|
            group.ToggleGroupItem(value: "bold") { "Bold" }
            group.ToggleGroupItem(value: "italic") { "Italic" }
            group.ToggleGroupItem(value: "underline") { "Underline" }
          end
        end
      end
    end
  end
end
