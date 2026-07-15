# frozen_string_literal: true

module Docs
  module Examples
    module Tabs
      # No Tabs(default:) — the active tab is marked server-side on the parts
      # (active: true), which must render styled pre-JS and survive hydration.
      class ServerActive < Phlex::HTML
        def view_template
          render PhlexKit::Tabs.new(class: "w-md") do
            render PhlexKit::TabsList.new do
              render PhlexKit::TabsTrigger.new(value: "overview") { "Overview" }
              render PhlexKit::TabsTrigger.new(value: "billing", active: true) { "Billing" }
              render PhlexKit::TabsTrigger.new(value: "usage") { "Usage" }
            end
            render PhlexKit::TabsContent.new(value: "overview") { "Overview panel" }
            render PhlexKit::TabsContent.new(value: "billing", active: true) { "Billing panel" }
            render PhlexKit::TabsContent.new(value: "usage") { "Usage panel" }
          end
        end
      end
    end
  end
end
