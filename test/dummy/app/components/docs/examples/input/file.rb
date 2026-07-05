# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class File < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "picture") { "Picture" }
              render PhlexKit::Input.new(id: "picture", type: :file)
              render PhlexKit::FormFieldHint.new { "Select a picture to upload." }
            end
          end
        end
      end
    end
  end
end
