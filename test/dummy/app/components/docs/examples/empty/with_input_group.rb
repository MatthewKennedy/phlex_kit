# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class WithInputGroup < Phlex::HTML
        def view_template
          render PhlexKit::Empty.new(class: "w-md") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyTitle.new { "404 - Not Found" }
              render PhlexKit::EmptyDescription.new { "The page you're looking for doesn't exist. Try searching for what you need below." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::InputGroup.new(style: "width: 75%") do
                render PhlexKit::InputGroupAddon.new do
                  render PhlexKit::Icon.new(:search, size: nil)
                end
                render PhlexKit::Input.new(placeholder: "Try searching for pages...")
                render PhlexKit::InputGroupAddon.new(align: :end) do
                  render PhlexKit::Kbd.new { "/" }
                end
              end
              render PhlexKit::EmptyDescription.new do
                plain "Need help? "
                a(href: "#") { "Contact support" }
              end
            end
          end
        end
      end
    end
  end
end
