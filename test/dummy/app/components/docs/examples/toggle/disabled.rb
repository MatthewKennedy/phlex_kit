# frozen_string_literal: true

module Docs
  module Examples
    module Toggle
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::Toggle.new(disabled: true, aria: { label: "Toggle underline" }) do
            render PhlexKit::Icon.new(:pencil, size: nil)
            plain "Disabled"
          end
        end
      end
    end
  end
end
