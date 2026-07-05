# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithSwitch < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(orientation: :horizontal, style: "width: fit-content") do
            render PhlexKit::FieldLabel.new(for: "fld-2fa") { "Multi-factor authentication" }
            render PhlexKit::Switch.new(id: "fld-2fa", name: "fld-2fa")
          end
        end
      end
    end
  end
end
