# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class Fieldset < Phlex::HTML
        def view_template
          fieldset(style: "border: 0; padding: 0; margin: 0;", class: "w-sm") do
            legend(style: "font-size: .875rem; font-weight: 500; padding: 0; margin-bottom: .25rem;") { "Notification method" }
            p(style: "margin: 0 0 .75rem; font-size: .875rem; color: var(--pk-muted);") { "Choose how you want to be notified." }
            render PhlexKit::RadioGroup.new do
              [ [ "all", "All new messages", true ], [ "mentions", "Direct messages and mentions", false ], [ "none", "Nothing", false ] ].each do |value, text, checked|
                render PhlexKit::Label.new(style: "font-weight: 400") do
                  render PhlexKit::RadioButton.new(name: "rg-notify", value: value, checked: checked)
                  plain text
                end
              end
            end
          end
        end
      end
    end
  end
end
