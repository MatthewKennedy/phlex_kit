# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class Responsive < Phlex::HTML
        def view_template
          # orientation: :responsive stacks vertically, then goes horizontal
          # once the enclosing FieldGroup is ≥28rem wide. Resize to see it.
          render PhlexKit::FieldGroup.new(style: "max-width: 40rem") do
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "fld-resp-name") { "Display name" }
                render PhlexKit::FieldDescription.new { "Shown on your public profile." }
              end
              render PhlexKit::Input.new(id: "fld-resp-name", placeholder: "Max Leiter", style: "max-width: 16rem")
            end
            render PhlexKit::FieldSeparator.new
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "fld-resp-marketing") { "Marketing emails" }
                render PhlexKit::FieldDescription.new { "Receive occasional product updates." }
              end
              render PhlexKit::Switch.new(id: "fld-resp-marketing", name: "fld-resp-marketing")
            end
          end
        end
      end
    end
  end
end
