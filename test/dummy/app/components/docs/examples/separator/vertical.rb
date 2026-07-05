# frozen_string_literal: true

module Docs
  module Examples
    module Separator
      class Vertical < Phlex::HTML
        def view_template
          div(class: "row", style: "height: 1.25rem; font-size: .875rem;") do
            div { "Blog" }
            render PhlexKit::Separator.new(orientation: :vertical)
            div { "Docs" }
            render PhlexKit::Separator.new(orientation: :vertical)
            div { "Source" }
          end
        end
      end
    end
  end
end
