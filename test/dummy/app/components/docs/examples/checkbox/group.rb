# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Group < Phlex::HTML
        ITEMS = [
          [ "hard-disks", "Hard disks", true ],
          [ "external-disks", "External disks", true ],
          [ "cds-dvds", "CDs, DVDs, and iPods", false ],
          [ "connected-servers", "Connected servers", false ]
        ].freeze

        def view_template
          render PhlexKit::FieldSet.new(class: "w-sm") do
            render PhlexKit::FieldLegend.new(variant: :label) { "Show these items on the desktop:" }
            render PhlexKit::FieldDescription.new { "Select the items you want to show on the desktop." }
            render PhlexKit::FieldGroup.new(style: "gap: .75rem") do
              ITEMS.each do |id, text, checked|
                render PhlexKit::Field.new(orientation: :horizontal) do
                  render PhlexKit::Checkbox.new(id: "finder-pref-#{id}", name: "finder-pref-#{id}", checked: checked)
                  render PhlexKit::FieldLabel.new(for: "finder-pref-#{id}", style: "font-weight: 400") { text }
                end
              end
            end
          end
        end
      end
    end
  end
end
