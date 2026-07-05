# frozen_string_literal: true

module Docs
  module Examples
    module Breadcrumb
      class Dropdown < Phlex::HTML
        def view_template
          render PhlexKit::Breadcrumb.new do
            render PhlexKit::BreadcrumbList.new do
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbLink.new(href: "#") { "Home" }
              end
              render PhlexKit::BreadcrumbSeparator.new
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::DropdownMenu.new do
                  render PhlexKit::DropdownMenuTrigger.new do
                    button(style: "display: flex; align-items: center; gap: .25rem;") do
                      plain "Components"
                      render PhlexKit::Icon.new(:chevron_down, size: 14)
                    end
                  end
                  render PhlexKit::DropdownMenuContent.new do
                    render PhlexKit::DropdownMenuGroup.new do
                      render PhlexKit::DropdownMenuItem.new(href: "#") { "Documentation" }
                      render PhlexKit::DropdownMenuItem.new(href: "#") { "Themes" }
                      render PhlexKit::DropdownMenuItem.new(href: "#") { "GitHub" }
                    end
                  end
                end
              end
              render PhlexKit::BreadcrumbSeparator.new
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbPage.new { "Breadcrumb" }
              end
            end
          end
        end
      end
    end
  end
end
