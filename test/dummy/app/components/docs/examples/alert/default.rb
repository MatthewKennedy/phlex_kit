# frozen_string_literal: true

module Docs
  module Examples
    module Alert
      class Default < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Alert.new do
              render PhlexKit::AlertTitle.new { "Success! Your changes have been saved" }
              render PhlexKit::AlertDescription.new { "This is an alert with title and description." }
            end
          end
        end
      end
    end
  end
end
