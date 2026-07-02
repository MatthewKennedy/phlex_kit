# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Label.new do
            render PhlexKit::Switch.new(name: "airplane")
            plain "Airplane Mode"
          end
          render PhlexKit::Label.new do
            render PhlexKit::Switch.new(name: "wifi", checked: true)
            plain "Wi-Fi"
          end
        end
      end
    end
  end
end
