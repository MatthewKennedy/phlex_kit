# frozen_string_literal: true

module Docs
  module Examples
    module Tabs
      class Icons < Phlex::HTML
        def view_template
          render PhlexKit::Tabs.new(default: "preview") do
            render PhlexKit::TabsList.new do
              render PhlexKit::TabsTrigger.new(value: "preview") do
                render PhlexKit::Icon.new(:eye, size: nil)
                plain "Preview"
              end
              render PhlexKit::TabsTrigger.new(value: "code") do
                render PhlexKit::Icon.new(:code, size: nil)
                plain "Code"
              end
            end
            render PhlexKit::TabsContent.new(value: "preview") { p { "Preview panel." } }
            render PhlexKit::TabsContent.new(value: "code") { p { "Code panel." } }
          end
        end
      end
    end
  end
end
