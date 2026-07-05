# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class WithIcon < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1.5rem") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Search...")
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::Icon.new(:search, size: nil)
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(type: :email, placeholder: "Enter your email")
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::Icon.new(:mail, size: nil)
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Card number")
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::Icon.new(:credit_card, size: nil)
              end
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::Icon.new(:check, size: nil)
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Card number")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::Icon.new(:star, size: nil)
                render PhlexKit::Icon.new(:info, size: nil)
              end
            end
          end
        end
      end
    end
  end
end
