# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class Styles < Phlex::HTML
        def view_template
          div(class: "stack w-lg") do
            render PhlexKit::Text.new(size: :xl, weight: :muted) { "Lead — a modal dialog that interrupts the user with important content." }
            render PhlexKit::Text.new(size: :lg, weight: :semibold) { "Large — are you absolutely sure?" }
            render PhlexKit::Text.new(size: :sm, weight: :medium) { "Small — email address" }
            render PhlexKit::Text.new(size: :sm, weight: :muted) { "Muted — enter your email address." }
          end
        end
      end
    end
  end
end
