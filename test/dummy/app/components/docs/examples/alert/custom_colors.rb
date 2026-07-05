# frozen_string_literal: true

module Docs
  module Examples
    module Alert
      class CustomColors < Phlex::HTML
        def view_template
          div(class: "w-md") do
            # Any palette works: override the box's colors directly.
            # light-dark() follows the page theme via color-scheme.
            render PhlexKit::Alert.new(
              style: "border-color: light-dark(#fde68a, #78350f); " \
                     "background: light-dark(#fffbeb, #451a03); " \
                     "color: light-dark(#78350f, #fffbeb);"
            ) do
              render PhlexKit::Icon.new(:triangle_alert, size: nil)
              render PhlexKit::AlertTitle.new { "Your subscription will expire in 3 days." }
              render PhlexKit::AlertDescription.new do
                plain "Renew now to avoid service interruption or upgrade to a paid plan to continue using the service."
              end
            end
          end
        end
      end
    end
  end
end
