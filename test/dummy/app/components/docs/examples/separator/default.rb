# frozen_string_literal: true

module Docs
  module Examples
    module Separator
      class Default < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            strong(style: "font-size:.875rem") { "PhlexKit" }
            div(style: "font-size:.875rem;color:var(--pk-muted)") { "A vanilla-CSS component kit." }
            render PhlexKit::Separator.new(style: "margin-block:.75rem")
            div(class: "row", style: "height:1.25rem;font-size:.875rem") do
              span { "Docs" }
              render PhlexKit::Separator.new(orientation: :vertical)
              span { "Source" }
              render PhlexKit::Separator.new(orientation: :vertical)
              span { "Gallery" }
            end
          end
        end
      end
    end
  end
end
