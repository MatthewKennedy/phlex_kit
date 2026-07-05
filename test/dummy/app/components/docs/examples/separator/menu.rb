# frozen_string_literal: true

module Docs
  module Examples
    module Separator
      class Menu < Phlex::HTML
        SECTIONS = [
          [ "Settings", "Manage preferences" ],
          [ "Account", "Profile & security" ],
          [ "Help", "Support & docs" ]
        ].freeze

        def view_template
          div(class: "row", style: "gap: 1rem; font-size: .875rem; align-items: stretch;") do
            SECTIONS.each_with_index do |(title, hint), index|
              render PhlexKit::Separator.new(orientation: :vertical) if index.positive?
              div(class: "stack", style: "gap: .25rem") do
                span(style: "font-weight: 500") { title }
                span(style: "font-size: .75rem; color: var(--pk-muted);") { hint }
              end
            end
          end
        end
      end
    end
  end
end
