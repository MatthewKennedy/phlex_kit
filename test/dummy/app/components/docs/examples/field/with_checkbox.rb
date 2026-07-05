# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithCheckbox < Phlex::HTML
        ITEMS = [
          [ "hard-disks", "Hard disks", true ],
          [ "external-disks", "External disks", false ],
          [ "cds-dvds", "CDs, DVDs, and iPods", false ],
          [ "connected-servers", "Connected servers", false ]
        ].freeze

        def view_template
          render PhlexKit::FieldGroup.new(class: "w-sm") do
            render PhlexKit::FieldSet.new do
              render PhlexKit::FieldLegend.new(variant: :label) { "Show these items on the desktop" }
              render PhlexKit::FieldDescription.new { "Select the items you want to show on the desktop." }
              render PhlexKit::FieldGroup.new(style: "gap: .75rem") do
                ITEMS.each do |id, text, checked|
                  render PhlexKit::Field.new(orientation: :horizontal) do
                    render PhlexKit::Checkbox.new(id: "fld-#{id}", name: "fld-#{id}", checked: checked)
                    render PhlexKit::FieldLabel.new(for: "fld-#{id}", style: "font-weight: 400") { text }
                  end
                end
              end
            end
            render PhlexKit::FieldSeparator.new
            render PhlexKit::Field.new(orientation: :horizontal) do
              render PhlexKit::Checkbox.new(id: "fld-sync-folders", name: "fld-sync-folders", checked: true)
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "fld-sync-folders") { "Sync Desktop & Documents folders" }
                render PhlexKit::FieldDescription.new { "Your Desktop & Documents folders are being synced with iCloud Drive. You can access them from other devices." }
              end
            end
          end
        end
      end
    end
  end
end
