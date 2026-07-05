# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Outline < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline) { "Outline" }
        end
      end
    end
  end
end
