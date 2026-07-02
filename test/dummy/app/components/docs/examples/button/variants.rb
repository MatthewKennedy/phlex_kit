# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Variants < Phlex::HTML
        def view_template
          render PhlexKit::Button.new { "Default" }
          render PhlexKit::Button.new(variant: :secondary) { "Secondary" }
          render PhlexKit::Button.new(variant: :destructive) { "Destructive" }
          render PhlexKit::Button.new(variant: :outline) { "Outline" }
          render PhlexKit::Button.new(variant: :ghost) { "Ghost" }
          render PhlexKit::Button.new(variant: :link) { "Link" }
        end
      end
    end
  end
end
