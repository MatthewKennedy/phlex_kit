# frozen_string_literal: true

module Docs
  module Examples
    module Command
      class Shortcuts < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Command.new(data: { controller: "phlex-kit--command" }, style: "border: 1px solid var(--pk-border);") do
              render PhlexKit::CommandInput.new(autofocus: false)
              render PhlexKit::CommandList.new do
                render PhlexKit::CommandGroup.new(title: "Settings") do
                  render PhlexKit::CommandItem.new(value: "profile", href: "#") do
                    render PhlexKit::Icon.new(:user, size: nil)
                    span { "Profile" }
                    render PhlexKit::CommandShortcut.new { "⌘P" }
                  end
                  render PhlexKit::CommandItem.new(value: "billing", href: "#") do
                    render PhlexKit::Icon.new(:credit_card, size: nil)
                    span { "Billing" }
                    render PhlexKit::CommandShortcut.new { "⌘B" }
                  end
                  render PhlexKit::CommandItem.new(value: "settings", href: "#") do
                    render PhlexKit::Icon.new(:settings, size: nil)
                    span { "Settings" }
                    render PhlexKit::CommandShortcut.new { "⌘S" }
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
