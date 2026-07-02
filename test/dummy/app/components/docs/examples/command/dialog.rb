# frozen_string_literal: true

module Docs
  module Examples
    module Command
      class Dialog < Phlex::HTML
        def view_template
          render PhlexKit::CommandDialog.new do
            render PhlexKit::CommandDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) do
                plain "Open command palette "
                render PhlexKit::KbdGroup.new do
                  render PhlexKit::Kbd.new { "⌘" }
                  render PhlexKit::Kbd.new { "K" }
                end
              end
            end
            render PhlexKit::CommandDialogContent.new do
              render PhlexKit::Command.new do
                render PhlexKit::CommandInput.new
                render PhlexKit::CommandList.new do
                  render PhlexKit::CommandGroup.new(title: "Suggestions") do
                    render PhlexKit::CommandItem.new(value: "calendar", href: "#") { "Calendar" }
                    render PhlexKit::CommandItem.new(value: "search emoji", href: "#") { "Search Emoji" }
                    render PhlexKit::CommandItem.new(value: "calculator", href: "#") { "Calculator" }
                  end
                  render PhlexKit::CommandGroup.new(title: "Settings") do
                    render PhlexKit::CommandItem.new(value: "profile", href: "#") { "Profile" }
                    render PhlexKit::CommandItem.new(value: "billing", href: "#") { "Billing" }
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
end
