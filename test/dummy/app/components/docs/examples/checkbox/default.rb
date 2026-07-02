# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Label.new do
            render PhlexKit::Checkbox.new(name: "terms", checked: true)
            plain "Accept terms and conditions"
          end
        end
      end
    end
  end
end
