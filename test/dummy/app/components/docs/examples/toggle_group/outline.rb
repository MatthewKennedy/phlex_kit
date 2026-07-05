# frozen_string_literal: true

module Docs
  module Examples
    module ToggleGroup
      class Outline < Phlex::HTML
        def view_template
          render PhlexKit::ToggleGroup.new(type: :single, value: "left", variant: :outline) do |group|
            group.ToggleGroupItem(value: "left") { "Left" }
            group.ToggleGroupItem(value: "center") { "Center" }
            group.ToggleGroupItem(value: "right") { "Right" }
          end
        end
      end
    end
  end
end
