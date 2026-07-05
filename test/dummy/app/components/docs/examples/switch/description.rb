# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class Description < Phlex::HTML
        def view_template
          div(class: "row w-sm", style: "align-items: flex-start; justify-content: space-between;") do
            div do
              render PhlexKit::Label.new(for: "sw-share") { "Share across devices" }
              p(style: "margin: .25rem 0 0; font-size: .875rem; color: var(--pk-muted);") do
                plain "Focus is shared across devices, and turns off when you leave the app."
              end
            end
            render PhlexKit::Switch.new(id: "sw-share", name: "sw-share")
          end
        end
      end
    end
  end
end
