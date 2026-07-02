# frozen_string_literal: true

module Docs
  module Pages
    class HoverCard < Docs::BasePage
      self.description = "For sighted users to preview content available behind a link."
      def demos
        demo Docs::Examples::HoverCard::Default, title: "Default"
      end
    end
  end
end
