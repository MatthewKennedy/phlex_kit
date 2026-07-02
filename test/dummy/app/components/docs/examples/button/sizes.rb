# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Sizes < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Small" }
          render PhlexKit::Button.new(variant: :outline) { "Default" }
          render PhlexKit::Button.new(variant: :outline, size: :lg) { "Large" }
        end
      end
    end
  end
end
