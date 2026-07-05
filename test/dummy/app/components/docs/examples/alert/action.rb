# frozen_string_literal: true

module Docs
  module Examples
    module Alert
      class Action < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Alert.new do
              render PhlexKit::AlertTitle.new { "Dark mode is now available" }
              render PhlexKit::AlertDescription.new do
                plain "Enable it under your profile settings to get started."
              end
              render PhlexKit::AlertAction.new do
                render PhlexKit::Button.new(size: :sm) { "Enable" }
              end
            end
          end
        end
      end
    end
  end
end
