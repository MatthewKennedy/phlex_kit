# frozen_string_literal: true

module Docs
  module Pages
    class NativeSelect < Docs::BasePage
      self.description = "A styled native <select> — mobile-friendly, with grouped options."

      def demos
        demo Docs::Examples::NativeSelect::Default, title: "Default"
        demo Docs::Examples::NativeSelect::Groups, title: "Groups"
        demo Docs::Examples::NativeSelect::Disabled, title: "Disabled"
        demo Docs::Examples::NativeSelect::Invalid, title: "Invalid"
      end
    end
  end
end
