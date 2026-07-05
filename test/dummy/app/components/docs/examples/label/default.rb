# frozen_string_literal: true

module Docs
  module Examples
    module Label
      class Default < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Checkbox.new(id: "label-terms", name: "label-terms")
            render PhlexKit::Label.new(for: "label-terms") { "Accept terms and conditions" }
          end
        end
      end
    end
  end
end
