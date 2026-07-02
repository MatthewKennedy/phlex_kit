# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::Label.new do
            render PhlexKit::Checkbox.new(name: "notifications", disabled: true)
            plain "Enable notifications"
          end
        end
      end
    end
  end
end
