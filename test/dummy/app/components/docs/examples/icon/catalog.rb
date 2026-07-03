# frozen_string_literal: true

module Docs
  module Examples
    module Icon
      # Every canonical glyph with its name — the full set a host can rely on
      # resolving in all four libraries.
      class Catalog < Phlex::HTML
        def view_template
          div(style: "display:grid;grid-template-columns:repeat(auto-fill, minmax(9rem, 1fr));gap:.75rem") do
            PhlexKit::Icons.names.sort.each do |name|
              div(style: "display:flex;align-items:center;gap:.5rem;font-size:.75rem;color:var(--pk-text-2)") do
                render PhlexKit::Icon.new(name, size: 18)
                code { name.to_s }
              end
            end
          end
        end
      end
    end
  end
end
