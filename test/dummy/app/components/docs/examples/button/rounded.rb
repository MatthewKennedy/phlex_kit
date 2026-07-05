# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Rounded < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline, icon: true, style: "border-radius: 999px") do
            render PhlexKit::Icon.new(:chevron_up, size: nil)
          end
        end
      end
    end
  end
end
