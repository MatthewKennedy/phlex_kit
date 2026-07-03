# frozen_string_literal: true

module Docs
  module Pages
    class Icon < Docs::BasePage
      self.description = "Canonical glyphs from a pluggable library — Lucide (default), " \
                         "Tabler, Phosphor, or Remix via PhlexKit.config.icon_library. " \
                         "Every built-in component glyph renders through it."
      def demos
        demo Docs::Examples::Icon::Default, title: "Default"
        demo Docs::Examples::Icon::Libraries, title: "Libraries"
        demo Docs::Examples::Icon::Catalog, title: "Catalog"
      end
    end
  end
end
