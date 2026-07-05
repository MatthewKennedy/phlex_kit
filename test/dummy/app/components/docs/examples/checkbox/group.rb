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
          fieldset(style: "border: 0; padding: 0; margin: 0;") do
            legend(style: "font-size: .875rem; font-weight: 500; padding: 0;") { "Show these items on the desktop:" }
            p(style: "margin: .25rem 0 .75rem; font-size: .875rem; color: var(--pk-muted);") do
              plain "Select the items you want to show on the desktop."
            end
            div(class: "stack", style: "gap: .75rem;") do
              ITEMS.each do |id, text, checked|
                div(class: "pk-checkbox-row") do
                  render PhlexKit::Checkbox.new(id: "finder-pref-#{id}", name: "finder-pref-#{id}", checked: checked)
                  render PhlexKit::Label.new(for: "finder-pref-#{id}", style: "font-weight: 400;") { text }
                end
              end
            end
          end
        end
      end
    end
  end
end
