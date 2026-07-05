# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Description < Phlex::HTML
        def view_template
          div(class: "pk-checkbox-row", style: "align-items: flex-start;") do
            render PhlexKit::Checkbox.new(id: "terms-checkbox-desc", name: "terms-checkbox-desc", checked: true, style: "margin-top: .125rem")
            div do
              render PhlexKit::Label.new(for: "terms-checkbox-desc") { "Accept terms and conditions" }
              p(style: "margin: .25rem 0 0; font-size: .875rem; color: var(--pk-muted);") do
                plain "By clicking this checkbox, you agree to the terms and conditions."
              end
            end
          end
        end
      end
    end
  end
end
