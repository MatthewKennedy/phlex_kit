# frozen_string_literal: true

module Docs
  module Examples
    module Collapsible
      class SettingsPanel < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 20rem;") do
            render PhlexKit::Card.new(size: :sm) do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Radius" }
                render PhlexKit::CardDescription.new { "Set the corner radius of the element." }
              end
              render PhlexKit::CardContent.new do
                render PhlexKit::Collapsible.new(style: "display: flex; align-items: flex-start; gap: .5rem;") do
                  div(style: "display: grid; grid-template-columns: 1fr 1fr; gap: .5rem; width: 100%;") do
                    render PhlexKit::Input.new(id: "radius-x", placeholder: "0", value: "0", aria: { label: "Radius X" })
                    render PhlexKit::Input.new(id: "radius-y", placeholder: "0", value: "0", aria: { label: "Radius Y" })
                    render PhlexKit::CollapsibleContent.new(style: "grid-column: 1 / -1; display: grid; grid-template-columns: 1fr 1fr; gap: .5rem;") do
                      render PhlexKit::Input.new(id: "radius-x2", placeholder: "0", value: "0", aria: { label: "Radius X" })
                      render PhlexKit::Input.new(id: "radius-y2", placeholder: "0", value: "0", aria: { label: "Radius Y" })
                    end
                  end
                  render PhlexKit::CollapsibleTrigger.new do
                    render PhlexKit::Button.new(variant: :outline, icon: true, aria: { label: "Toggle corners" }) do
                      render PhlexKit::Icon.new(:chevrons_up_down, size: nil)
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
end
