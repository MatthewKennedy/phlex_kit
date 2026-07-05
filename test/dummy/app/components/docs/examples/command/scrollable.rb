# frozen_string_literal: true

module Docs
  module Examples
    module Command
      class Scrollable < Phlex::HTML
        GROUPS = {
          "Fruits" => %w[Apple Banana Blueberry Grapes Pineapple],
          "Vegetables" => %w[Aubergine Broccoli Carrot Courgette Leek],
          "Meat" => %w[Beef Chicken Lamb Pork],
          "Fish" => %w[Cod Haddock Salmon Trout Tuna],
          "Grains" => %w[Barley Oats Quinoa Rice Wheat]
        }.freeze

        def view_template
          div(class: "w-sm") do
            # The list caps at max-h-72 and scrolls; the scrollbar is hidden.
            render PhlexKit::Command.new(data: { controller: "phlex-kit--command" }, style: "border: 1px solid var(--pk-border);") do
              render PhlexKit::CommandInput.new(autofocus: false)
              render PhlexKit::CommandList.new do
                GROUPS.each_with_index do |(title, items), index|
                  render PhlexKit::CommandSeparator.new if index.positive?
                  render PhlexKit::CommandGroup.new(title: title) do
                    items.each do |item|
                      render PhlexKit::CommandItem.new(value: item.downcase, href: "#") { item }
                    end
                  end
                end
              end
              render PhlexKit::CommandEmpty.new { "No results found." }
            end
          end
        end
      end
    end
  end
end
