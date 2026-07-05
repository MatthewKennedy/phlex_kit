# frozen_string_literal: true

module Docs
  module Examples
    module Tabs
      class Line < Phlex::HTML
        def view_template
          render PhlexKit::Tabs.new(default: "overview") do
            render PhlexKit::TabsList.new(variant: :line) do
              render PhlexKit::TabsTrigger.new(value: "overview") { "Overview" }
              render PhlexKit::TabsTrigger.new(value: "analytics") { "Analytics" }
              render PhlexKit::TabsTrigger.new(value: "reports") { "Reports" }
            end
            render PhlexKit::TabsContent.new(value: "overview") { p { "Overview panel." } }
            render PhlexKit::TabsContent.new(value: "analytics") { p { "Analytics panel." } }
            render PhlexKit::TabsContent.new(value: "reports") { p { "Reports panel." } }
          end
        end
      end
    end
  end
end
