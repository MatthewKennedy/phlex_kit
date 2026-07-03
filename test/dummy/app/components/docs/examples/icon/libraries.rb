# frozen_string_literal: true

module Docs
  module Examples
    module Icon
      # The same glyphs drawn by each vendored library (per-instance library:
      # override; hosts normally set PhlexKit.config.icon_library once).
      class Libraries < Phlex::HTML
        GLYPHS = %i[chevron_down check x search calendar user settings trash mail bell].freeze

        def view_template
          div(style: "display:grid;grid-template-columns:auto repeat(#{GLYPHS.size}, 1fr);gap:.5rem 1rem;align-items:center") do
            PhlexKit::Icons::MODULES.each_key do |library|
              span(style: "font-size:.8rem;color:var(--pk-muted)") { library.to_s }
              GLYPHS.each do |glyph|
                render PhlexKit::Icon.new(glyph, library: library, size: 18)
              end
            end
          end
        end
      end
    end
  end
end
