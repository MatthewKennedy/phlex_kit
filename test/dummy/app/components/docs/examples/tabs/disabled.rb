# frozen_string_literal: true

module Docs
  module Examples
    module Tabs
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::Tabs.new(default: "active") do
            render PhlexKit::TabsList.new do
              render PhlexKit::TabsTrigger.new(value: "active") { "Active" }
              render PhlexKit::TabsTrigger.new(value: "disabled", disabled: true) { "Disabled" }
            end
            render PhlexKit::TabsContent.new(value: "active") { p { "The other tab is disabled." } }
          end
        end
      end
    end
  end
end
