# frozen_string_literal: true

module Docs
  module Examples
    module Textarea
      class Default < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Textarea.new(placeholder: "Type your message here.")
          end
        end
      end
    end
  end
end
