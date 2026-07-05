# frozen_string_literal: true

module Docs
  module Examples
    module Alert
      class Destructive < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Alert.new(variant: :destructive) do
              render PhlexKit::Icon.new(:circle_alert, size: nil)
              render PhlexKit::AlertTitle.new { "Payment failed" }
              render PhlexKit::AlertDescription.new do
                plain "Your payment could not be processed. Please check your payment method and try again."
              end
            end
          end
        end
      end
    end
  end
end
