# frozen_string_literal: true

module Docs
  module Pages
    class HoverCard < Docs::BasePage
      self.description = "For sighted users to preview content available behind a link."

      def demos
        demo Docs::Examples::HoverCard::Basic, title: "Basic"
        demo Docs::Examples::HoverCard::Sides, title: "Sides"
      end
    end
  end
end
