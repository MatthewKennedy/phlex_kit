# frozen_string_literal: true

module Docs
  module Pages
    class Codeblock < Docs::BasePage
      self.description = "Plain, dependency-free code block. Every Code tab on this site shows the bring-your-own-highlighter pattern: rouge output passed as a block (raw safe(html)), colored via .pk-codeblock token rules."
      def demos
        demo Docs::Examples::Codeblock::Default, title: "Default"
      end
    end
  end
end
