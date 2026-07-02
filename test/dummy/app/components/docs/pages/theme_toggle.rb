# frozen_string_literal: true

module Docs
  module Pages
    class ThemeToggle < Docs::BasePage
      self.description = "Flips :root[data-theme] between dark and light — try it, this page follows."
      def demos
        demo Docs::Examples::ThemeToggle::Default, title: "Default"
      end
    end
  end
end
