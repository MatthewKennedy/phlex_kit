# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Basic < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Input.new(placeholder: "Enter text")
          end
        end
      end
    end
  end
end
