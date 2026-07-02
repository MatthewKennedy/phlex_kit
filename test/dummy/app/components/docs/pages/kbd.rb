# frozen_string_literal: true

module Docs
  module Pages
    class Kbd < Docs::BasePage
      self.description = "Displays keyboard input or shortcuts."
      def demos
        demo Docs::Examples::Kbd::Default, title: "Default"
      end
    end
  end
end
