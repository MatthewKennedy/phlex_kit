# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Link < Phlex::HTML
        def view_template
          div(class: "stack w-md") do
            render PhlexKit::Item.new(href: "#") do
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "Visit our documentation" }
                render PhlexKit::ItemDescription.new { "Learn how to get started with our components." }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::Icon.new(:chevron_right)
              end
            end
            render PhlexKit::Item.new(variant: :outline, href: "#", target: "_blank", rel: "noopener noreferrer") do
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "External resource" }
                render PhlexKit::ItemDescription.new { "Opens in a new tab with security attributes." }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::Icon.new(:external_link)
              end
            end
          end
        end
      end
    end
  end
end
