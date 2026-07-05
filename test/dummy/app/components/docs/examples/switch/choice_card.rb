# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class ChoiceCard < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            label(style: "display: flex; gap: .75rem; align-items: flex-start; justify-content: space-between; border: 1px solid var(--pk-border); border-radius: var(--pk-radius); padding: .75rem; cursor: pointer;") do
              div do
                div(style: "font-size: .875rem; font-weight: 500;") { "Enable notifications" }
                p(style: "margin: .25rem 0 0; font-size: .875rem; color: var(--pk-muted);") { "Get notified when someone mentions you." }
              end
              render PhlexKit::Switch.new(name: "sw-card", checked: true)
            end
          end
        end
      end
    end
  end
end
