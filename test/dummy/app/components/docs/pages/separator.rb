# frozen_string_literal: true

module Docs
  module Pages
    class Separator < Docs::BasePage
      self.description = "Visually or semantically separates content."
      def demos
        demo Docs::Examples::Separator::Default, title: "Default"
      end
    end
  end
end
