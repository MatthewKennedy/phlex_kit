# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Default < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Input.new(type: :email, placeholder: "Email")
          end
        end
      end
    end
  end
end
