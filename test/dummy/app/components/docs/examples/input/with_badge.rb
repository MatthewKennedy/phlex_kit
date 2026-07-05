# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class WithBadge < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(class: "w-sm") do
            render PhlexKit::FieldLabel.new(for: "input-badge", style: "width: 100%") do
              plain "Webhook URL"
              render PhlexKit::Badge.new(variant: :secondary, style: "margin-left: auto") { "Beta" }
            end
            render PhlexKit::Input.new(id: "input-badge", type: :url, placeholder: "https://api.example.com/webhook")
          end
        end
      end
    end
  end
end
