# frozen_string_literal: true

module Docs
  module Examples
    module Breadcrumb
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Breadcrumb.new do
            render PhlexKit::BreadcrumbList.new do
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbLink.new(href: "#") { "Home" }
              end
              render PhlexKit::BreadcrumbSeparator.new
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbEllipsis.new
              end
              render PhlexKit::BreadcrumbSeparator.new
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbLink.new(href: "#") { "Components" }
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
