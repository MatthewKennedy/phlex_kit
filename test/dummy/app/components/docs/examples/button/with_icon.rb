# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class WithIcon < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline) do
            span { "✉" }
            plain " Email login link"
          end
        end
      end
    end
  end
end
