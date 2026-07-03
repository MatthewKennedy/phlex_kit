# frozen_string_literal: true

module Docs
  module Pages
    class Accordion < Docs::BasePage
      self.description = "A vertically stacked set of interactive headings that each reveal a section of content."
      def demos
        demo Docs::Examples::Accordion::Default, title: "Basic"
        demo Docs::Examples::Accordion::Multiple, title: "Multiple"
        demo Docs::Examples::Accordion::Disabled, title: "Disabled"
        demo Docs::Examples::Accordion::Borders, title: "Borders"
        demo Docs::Examples::Accordion::InCard, title: "Card"
      end
    end
  end
end
