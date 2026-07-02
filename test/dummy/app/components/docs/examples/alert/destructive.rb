# frozen_string_literal: true

module Docs
  module Examples
    module Alert
      class Destructive < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Alert.new(variant: :destructive) do
              render PhlexKit::AlertTitle.new { "Unable to process your payment." }
              render PhlexKit::AlertDescription.new { "Please verify your billing information and try again." }
            end
          end
        end
      end
    end
  end
end
