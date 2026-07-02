# frozen_string_literal: true

module Docs
  module Pages
    class ShortcutKey < Docs::BasePage
      self.description = "ruby_ui's keyboard chip (Kbd is the shadcn-parity spelling)."
      def demos
        demo Docs::Examples::ShortcutKey::Default, title: "Default"
      end
    end
  end
end
