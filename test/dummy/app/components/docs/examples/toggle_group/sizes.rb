# frozen_string_literal: true

module Docs
  module Examples
    module ToggleGroup
      class Sizes < Phlex::HTML
        def view_template
          div(class: "stack", style: "align-items: flex-start; gap: 1rem;") do
            [ :sm, :default, :lg ].each do |size|
              render PhlexKit::ToggleGroup.new(type: :multiple, variant: :outline, size: size) do |group|
                group.ToggleGroupItem(value: "bold") { "B" }
                group.ToggleGroupItem(value: "italic") { "I" }
                group.ToggleGroupItem(value: "underline") { "U" }
              end
            end
          end
        end
      end
    end
  end
end
