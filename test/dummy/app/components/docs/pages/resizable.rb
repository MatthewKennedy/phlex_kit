# frozen_string_literal: true

module Docs
  module Pages
    class Resizable < Docs::BasePage
      self.description = "Accessible resizable panel groups and layouts with keyboard support."

      def demos
        demo Docs::Examples::Resizable::Horizontal, title: "Default"
        demo Docs::Examples::Resizable::Vertical, title: "Vertical"
        demo Docs::Examples::Resizable::WithHandle, title: "Handle"
      end
    end
  end
end
