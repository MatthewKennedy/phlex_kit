# frozen_string_literal: true

module Docs
  module Examples
    module Switch
      class Invalid < Phlex::HTML
        def view_template
          render PhlexKit::Switch.new(name: "sw-invalid", aria: { invalid: "true" })
        end
      end
    end
  end
end
