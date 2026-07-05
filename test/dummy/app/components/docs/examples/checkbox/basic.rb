# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Basic < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(orientation: :horizontal, style: "width: fit-content") do
            render PhlexKit::Checkbox.new(id: "terms-checkbox-basic", name: "terms-checkbox-basic")
            render PhlexKit::FieldLabel.new(for: "terms-checkbox-basic") { "Accept terms and conditions" }
          end
        end
      end
    end
  end
end
