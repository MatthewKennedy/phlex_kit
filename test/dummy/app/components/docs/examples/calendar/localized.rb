# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class Localized < Phlex::HTML
        def view_template
          # `locale:` (a BCP 47 tag) drives every Intl call the controller
          # makes: caption, weekday headers, month dropdown and each day's
          # accessible name. Unset follows the browser's own locale.
          div(style: "border: 1px solid var(--pk-border); border-radius: var(--pk-radius); width: fit-content;") do
            render PhlexKit::Calendar.new(selected_date: "2026-06-12", caption_layout: :dropdown,
              from_year: 2020, to_year: 2030, locale: "fr-FR")
          end
        end
      end
    end
  end
end
