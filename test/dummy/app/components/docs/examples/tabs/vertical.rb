# frozen_string_literal: true

module Docs
  module Examples
    module Tabs
      class Vertical < Phlex::HTML
        def view_template
          render PhlexKit::Tabs.new(default: "account", orientation: :vertical, style: "gap: 1rem") do
            render PhlexKit::TabsList.new do
              render PhlexKit::TabsTrigger.new(value: "account") { "Account" }
              render PhlexKit::TabsTrigger.new(value: "password") { "Password" }
              render PhlexKit::TabsTrigger.new(value: "notifications") { "Notifications" }
            end
            render PhlexKit::TabsContent.new(value: "account") { p(style: "margin: 0") { "Account settings." } }
            render PhlexKit::TabsContent.new(value: "password") { p(style: "margin: 0") { "Change your password." } }
            render PhlexKit::TabsContent.new(value: "notifications") { p(style: "margin: 0") { "Notification preferences." } }
          end
        end
      end
    end
  end
end
