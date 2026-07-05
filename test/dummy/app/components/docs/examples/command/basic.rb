# frozen_string_literal: true

module Docs
  module Examples
    module Command
      class Basic < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            # Inline palette: add the controller yourself (dialogs wire it up automatically).
            render PhlexKit::Command.new(data: { controller: "phlex-kit--command" }, style: "border: 1px solid var(--pk-border);") do
              render PhlexKit::CommandInput.new(autofocus: false)
              render PhlexKit::CommandList.new do
                render PhlexKit::CommandGroup.new(title: "Suggestions") do
                  render PhlexKit::CommandItem.new(value: "calendar", href: "#") { "Calendar" }
                  render PhlexKit::CommandItem.new(value: "search emoji", href: "#") { "Search Emoji" }
                  render PhlexKit::CommandItem.new(value: "calculator", href: "#") { "Calculator" }
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
