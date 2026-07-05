# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Secondary < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :secondary) { "Secondary" }
        end
      end
    end
  end
end
