# frozen_string_literal: true

module Docs
  module Pages
    class Accordion < Docs::BasePage
      self.description = "A vertically stacked set of interactive headings that each reveal a section of content."

      def demos
        demo Docs::Examples::Accordion::Default, title: "Default"
      end
    end
  end
end
