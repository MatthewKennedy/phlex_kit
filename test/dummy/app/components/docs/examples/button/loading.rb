# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Loading < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(disabled: true) do
            render PhlexKit::Spinner.new(size: :sm)
            plain " Please wait"
          end
        end
      end
    end
  end
end
