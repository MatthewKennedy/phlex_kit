# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Icon < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline, icon: true) do
            render PhlexKit::Icon.new(:refresh, size: nil)
          end
        end
      end
    end
  end
end
