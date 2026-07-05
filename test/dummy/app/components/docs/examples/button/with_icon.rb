# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class WithIcon < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline, size: :sm) do
            render PhlexKit::Icon.new(:code, size: nil)
            plain " New Branch"
          end
        end
      end
    end
  end
end
