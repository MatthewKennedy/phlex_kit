# frozen_string_literal: true

module Docs
  module Pages
    class Popover < Docs::BasePage
      self.description = "Displays rich content in a portal, triggered by a button."
      def demos
        demo Docs::Examples::Popover::Dimensions, title: "Dimensions"
      end
    end
  end
end
