# frozen_string_literal: true

require "phlex_kit/icons/lucide"
require "phlex_kit/icons/tabler"
require "phlex_kit/icons/phosphor"
require "phlex_kit/icons/remix"

module PhlexKit
  # Registry over the vendored icon data modules. Components (and hosts, via
  # PhlexKit::Icon) look glyphs up by canonical semantic name — the per-library
  # vocabulary mapping (Phosphor "caret-down", Remix "arrow-down-s-line", …)
  # was resolved at generation time by scripts/generate_icons.rb.
  #
  # HugeIcons is deliberately absent: its free set's terms forbid editing and
  # redistribution of the artwork, so it cannot ship inside this MIT gem.
  module Icons
    MODULES = {
      lucide: Lucide,
      tabler: Tabler,
      phosphor: Phosphor,
      remix: Remix
    }.freeze

    # => { elements:, view_box:, mode: :stroke|:fill, stroke_width: }
    # Fails loud (KeyError) on an unknown library or glyph.
    def self.fetch(name, library: PhlexKit.config.icon_library)
      mod = MODULES.fetch(library.to_sym) do
        raise KeyError, "Unknown icon library #{library.inspect} — available: #{MODULES.keys.join(', ')}"
      end
      elements = mod::ICONS.fetch(name.to_sym) do
        raise KeyError, "Unknown icon #{name.inspect} in #{library} — available: #{mod::ICONS.keys.join(', ')}"
      end
      { elements: elements, view_box: mod::VIEW_BOX, mode: mod::MODE, stroke_width: mod::STROKE_WIDTH }
    end

    def self.names
      MODULES.fetch(:lucide)::ICONS.keys
    end
  end
end
