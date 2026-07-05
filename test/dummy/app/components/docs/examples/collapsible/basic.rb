# frozen_string_literal: true

module Docs
  module Examples
    module Collapsible
      class Basic < Phlex::HTML
        def view_template
          style { safe(".docs-collapsible-basic[data-state='open'] { background: var(--pk-surface-2); border-radius: calc(var(--pk-radius) - 2px); }") }
          div(class: "w-sm") do
            render PhlexKit::Card.new do
              render PhlexKit::CardContent.new do
                render PhlexKit::Collapsible.new(class: "docs-collapsible-basic") do
                  render PhlexKit::CollapsibleTrigger.new do
                    render PhlexKit::Button.new(variant: :ghost, style: "width: 100%") do
                      plain "Product details"
                      render PhlexKit::Icon.new(:chevron_down, size: nil, class: "pk-collapsible-chevron", style: "margin-left: auto")
                    end
                  end
                  render PhlexKit::CollapsibleContent.new(style: "display: flex; flex-direction: column; align-items: flex-start; gap: .5rem; padding: 0 .625rem .625rem; font-size: .875rem;") do
                    div { "This panel can be expanded or collapsed to reveal additional content." }
                    render PhlexKit::Button.new(size: :xs) { "Learn More" }
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
