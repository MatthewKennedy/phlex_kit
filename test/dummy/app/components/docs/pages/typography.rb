# frozen_string_literal: true

module Docs
  module Pages
    class Typography < Docs::BasePage
      self.description = "Headings, text, blockquotes, inline code and links."
      def demos
        demo Docs::Examples::Typography::Default, title: "Specimen"
      end
    end
  end
end
