# frozen_string_literal: true

module Docs
  module Pages
    class Resizable < Docs::BasePage
      self.description = "Accessible resizable panel groups with drag handles."
      def demos
        demo Docs::Examples::Resizable::Horizontal, title: "Horizontal"
        demo Docs::Examples::Resizable::Vertical, title: "Vertical"
      end
    end
  end
end
