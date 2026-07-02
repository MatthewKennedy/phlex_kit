# frozen_string_literal: true

module Docs
  module Pages
    class Codeblock < Docs::BasePage
      self.description = "Plain, dependency-free code block (no rouge — bring your own highlighter)."
      def demos
        demo Docs::Examples::Codeblock::Default, title: "Default"
      end
    end
  end
end
