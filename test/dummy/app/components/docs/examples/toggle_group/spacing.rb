# frozen_string_literal: true

module Docs
  module Examples
    module ToggleGroup
      class Spacing < Phlex::HTML
        def view_template
          # spacing: 0 (default) joins the items; N > 0 gaps them by N × .25rem.
          render PhlexKit::ToggleGroup.new(type: :multiple, variant: :outline, spacing: 1) do |group|
            group.ToggleGroupItem(value: "bold") { "Bold" }
            group.ToggleGroupItem(value: "italic") { "Italic" }
            group.ToggleGroupItem(value: "underline") { "Underline" }
          end
          render PhlexKit::ToggleGroup.new(type: :multiple, variant: :outline, spacing: 4) do |group|
            group.ToggleGroupItem(value: "bold") { "Bold" }
            group.ToggleGroupItem(value: "italic") { "Italic" }
            group.ToggleGroupItem(value: "underline") { "Underline" }
          end
        end
      end
    end
  end
end
