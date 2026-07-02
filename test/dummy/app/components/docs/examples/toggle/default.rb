# frozen_string_literal: true

module Docs
  module Examples
    module Toggle
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Toggle.new(name: "bold", aria: { label: "Toggle bold" }) { "B" }
          render PhlexKit::Toggle.new(name: "italic", pressed: true, aria: { label: "Toggle italic" }) { "I" }
        end
      end
    end
  end
end
