# frozen_string_literal: true

module Docs
  module Examples
    module Alert
      class Basic < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Alert.new do
              render PhlexKit::Icon.new(:circle_check, size: nil)
              render PhlexKit::AlertTitle.new { "Account updated successfully" }
              render PhlexKit::AlertDescription.new do
                plain "Your profile information has been saved. Changes will be reflected immediately."
              end
            end
          end
        end
      end
    end
  end
end
