# frozen_string_literal: true

module Docs
  module Examples
    module Collapsible
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Collapsible.new(class: "w-md") do
            div(class: "row", style: "justify-content: space-between") do
              span(style: "font-size:.875rem;font-weight:500") { "@peduarte starred 3 repositories" }
              render PhlexKit::CollapsibleTrigger.new do
                render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Toggle" }) { "⌄" }
              end
            end
            div(class: "docs-repo-row") { "@radix-ui/primitives" }
            render PhlexKit::CollapsibleContent.new do
              div(class: "stack", style: "margin-top:.5rem") do
                div(class: "docs-repo-row") { "@radix-ui/colors" }
                div(class: "docs-repo-row") { "@stitches/react" }
              end
            end
          end
        end
      end
    end
  end
end
