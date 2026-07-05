# frozen_string_literal: true

module Docs
  module Examples
    module Textarea
      class Invalid < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Textarea.new(placeholder: "Type your message here.", aria: { invalid: "true" })
          end
        end
      end
    end
  end
end
