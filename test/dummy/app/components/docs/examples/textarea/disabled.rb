# frozen_string_literal: true

module Docs
  module Examples
    module Textarea
      class Disabled < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Textarea.new(placeholder: "Type your message here.", disabled: true)
          end
        end
      end
    end
  end
end
