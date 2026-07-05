# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class ChoiceCard < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::FieldLabel.new do
              render PhlexKit::Field.new(orientation: :horizontal) do
                render PhlexKit::FieldContent.new do
                  render PhlexKit::FieldTitle.new { "Enable notifications" }
                  render PhlexKit::FieldDescription.new { "Get notified when someone mentions you." }
                end
                render PhlexKit::Switch.new(name: "sw-card", checked: true)
              end
            end
          end
        end
      end
    end
  end
end
