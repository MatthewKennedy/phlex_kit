# frozen_string_literal: true

module Docs
  module Pages
    class Popover < Docs::BasePage
      self.description = "Displays rich content in a portal, triggered by a button."

      def demos
        demo Docs::Examples::Popover::Basic, title: "Basic"
        demo Docs::Examples::Popover::Align, title: "Align"
        demo Docs::Examples::Popover::WithForm, title: "With Form"
      end
    end
  end
end
