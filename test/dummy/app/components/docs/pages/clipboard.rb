# frozen_string_literal: true

module Docs
  module Pages
    class Clipboard < Docs::BasePage
      self.description = "Copies its source content to the clipboard, with success/error feedback."
      def demos
        demo Docs::Examples::Clipboard::Default, title: "Default"
      end
    end
  end
end
