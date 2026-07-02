# frozen_string_literal: true

module Docs
  module Examples
    module Spinner
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Spinner.new(size: :sm)
          render PhlexKit::Spinner.new
          render PhlexKit::Spinner.new(size: :lg)
          render PhlexKit::Button.new(disabled: true) do
            render PhlexKit::Spinner.new(size: :sm)
            plain " Loading…"
          end
        end
      end
    end
  end
end
