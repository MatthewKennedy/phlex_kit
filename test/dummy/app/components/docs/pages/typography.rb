# frozen_string_literal: true

module Docs
  module Pages
    class Typography < Docs::BasePage
      self.description = "Styles for headings, paragraphs, lists, tables and prose accents."
      def demos
        demo Docs::Examples::Typography::Headings, title: "Headings"
        demo Docs::Examples::Typography::Paragraph, title: "Paragraph & blockquote"
        demo Docs::Examples::Typography::List, title: "List"
        demo Docs::Examples::Typography::ProseTable, title: "Table"
        demo Docs::Examples::Typography::InlineCode, title: "Inline code"
        demo Docs::Examples::Typography::Styles, title: "Lead, Large, Small, Muted"
      end
    end
  end
end
