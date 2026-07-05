# frozen_string_literal: true

module Docs
  module Examples
    module Breadcrumb
      class CustomSeparator < Phlex::HTML
        def view_template
          render PhlexKit::Breadcrumb.new do
            render PhlexKit::BreadcrumbList.new do
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbLink.new(href: "#") { "Home" }
              end
              # Any block replaces the default chevron.
              render PhlexKit::BreadcrumbSeparator.new { dot }
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbLink.new(href: "#") { "Components" }
              end
              render PhlexKit::BreadcrumbSeparator.new { dot }
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbPage.new { "Breadcrumb" }
              end
            end
          end
        end

        private

        def dot
          svg(viewbox: "0 0 24 24", fill: "none", stroke: "currentColor", stroke_width: "2", stroke_linecap: "round", stroke_linejoin: "round") do |s|
            s.circle(cx: "12.1", cy: "12.1", r: "1")
          end
        end
      end
    end
  end
end
