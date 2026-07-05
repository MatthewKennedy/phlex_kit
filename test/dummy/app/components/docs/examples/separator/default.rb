# frozen_string_literal: true

module Docs
  module Examples
    module Separator
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1rem; font-size: .875rem;") do
            div(class: "stack", style: "gap: .375rem") do
              div(style: "font-weight: 500; line-height: 1;") { "PhlexKit" }
              div(style: "color: var(--pk-muted)") { "The Foundation for your Design System" }
            end
            render PhlexKit::Separator.new
            div { "A set of beautifully designed components that you can customize, extend, and build on." }
          end
        end
      end
    end
  end
end
