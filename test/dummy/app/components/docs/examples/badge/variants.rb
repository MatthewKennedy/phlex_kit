# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class Variants < Phlex::HTML
        def view_template
          render PhlexKit::Badge.new { "Badge" }
          render PhlexKit::Badge.new(variant: :secondary) { "Secondary" }
          render PhlexKit::Badge.new(variant: :destructive) { "Destructive" }
          render PhlexKit::Badge.new(variant: :outline) { "Outline" }
        end
      end
    end
  end
end
