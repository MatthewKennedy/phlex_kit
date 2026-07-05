# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class Description < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(orientation: :horizontal, class: "w-sm") do
            render PhlexKit::FieldContent.new do
              render PhlexKit::FieldLabel.new(for: "sw-share") { "Share across devices" }
              render PhlexKit::FieldDescription.new { "Focus is shared across devices, and turns off when you leave the app." }
            end
            render PhlexKit::Switch.new(id: "sw-share", name: "sw-share")
          end
        end
      end
    end
  end
end
