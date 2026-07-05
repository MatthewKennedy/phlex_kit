# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class File < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(class: "w-sm") do
            render PhlexKit::FieldLabel.new(for: "picture") { "Picture" }
            render PhlexKit::Input.new(id: "picture", type: :file)
            render PhlexKit::FieldDescription.new { "Select a picture to upload." }
          end
        end
      end
    end
  end
end
