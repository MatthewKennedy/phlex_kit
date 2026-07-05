# frozen_string_literal: true

module Docs
  module Examples
    module Kbd
      class InButton < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline) do
            plain "Accept "
            render PhlexKit::Kbd.new(data: { icon: "inline-end" }) { "⏎" }
          end
        end
      end
    end
  end
end
