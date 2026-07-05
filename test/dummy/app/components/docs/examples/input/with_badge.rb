# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class WithBadge < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "input-badge", style: "display: flex; align-items: center;") do
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
end
