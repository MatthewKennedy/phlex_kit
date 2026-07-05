# frozen_string_literal: true

module Docs
  module Examples
    module Textarea
      class WithButton < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: .5rem") do
            render PhlexKit::Textarea.new(placeholder: "Type your message here.")
            render PhlexKit::Button.new { "Send message" }
          end
        end
      end
    end
  end
end
