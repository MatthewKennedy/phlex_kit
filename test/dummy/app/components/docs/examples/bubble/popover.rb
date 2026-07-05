# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Popover < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(align: :end) do
              render PhlexKit::BubbleContent.new { "Run the build script." }
            end
            render PhlexKit::Bubble.new(variant: :destructive) do
              render PhlexKit::BubbleContent.new { "Failed to run the command." }
              render PhlexKit::BubbleReactions.new do
                render PhlexKit::Popover.new do
                  render PhlexKit::PopoverTrigger.new do
                    render PhlexKit::Button.new(variant: :ghost, size: :xs, icon: true, aria: { label: "Show error details" }) do
                      render PhlexKit::Icon.new(:info)
                    end
                  end
                  render PhlexKit::PopoverContent.new do
                    strong(style: "font-size: .875rem; display: block; margin-bottom: .25rem;") { "Command failed with exit code 1" }
                    p(style: "font-size: .875rem; margin: 0; color: var(--pk-muted);") { "ENOENT: no such file or directory, open pnpm-lock.yaml" }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
