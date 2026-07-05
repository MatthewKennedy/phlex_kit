# frozen_string_literal: true

module Docs
  module Examples
    module Toggle
      class Outline < Phlex::HTML
        def view_template
          render PhlexKit::Toggle.new(variant: :outline, aria: { label: "Toggle italic" }) do
            render PhlexKit::Icon.new(:pencil, size: nil)
          end
        end
      end
    end
  end
end
