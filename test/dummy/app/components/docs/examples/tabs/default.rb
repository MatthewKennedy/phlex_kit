# frozen_string_literal: true

module Docs
  module Examples
    module Tabs
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Tabs.new(default: "account", class: "w-md") do
            render PhlexKit::TabsList.new do
              render PhlexKit::TabsTrigger.new(value: "account") { "Account" }
              render PhlexKit::TabsTrigger.new(value: "password") { "Password" }
            end
            render PhlexKit::TabsContent.new(value: "account") do
              div(style: "padding:1rem 0;font-size:.875rem;color:var(--pk-muted)") { "Make changes to your account here." }
            end
            render PhlexKit::TabsContent.new(value: "password") do
              div(style: "padding:1rem 0;font-size:.875rem;color:var(--pk-muted)") { "Change your password here." }
            end
          end
        end
      end
    end
  end
end
