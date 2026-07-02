# frozen_string_literal: true

module Docs
  module Examples
    module NavigationMenu
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::NavigationMenu.new do
            render PhlexKit::NavigationMenuList.new do
              render PhlexKit::NavigationMenuItem.new do
                render PhlexKit::NavigationMenuTrigger.new { "Getting started" }
                render PhlexKit::NavigationMenuContent.new do
                  render PhlexKit::NavigationMenuLink.new(href: "#") { "Installation" }
                  render PhlexKit::NavigationMenuLink.new(href: "#") { "Theming" }
                  render PhlexKit::NavigationMenuLink.new(href: "#") { "Typography" }
                end
              end
              render PhlexKit::NavigationMenuItem.new do
                render PhlexKit::NavigationMenuTrigger.new { "Components" }
                render PhlexKit::NavigationMenuContent.new do
                  render PhlexKit::NavigationMenuLink.new(href: "#") { "Button" }
                  render PhlexKit::NavigationMenuLink.new(href: "#") { "Dialog" }
                end
              end
              render PhlexKit::NavigationMenuItem.new do
                render PhlexKit::NavigationMenuLink.new(href: "#") { "Docs" }
              end
            end
          end
        end
      end
    end
  end
end
