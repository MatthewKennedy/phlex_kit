# frozen_string_literal: true

module Docs
  module Pages
    class Collapsible < Docs::BasePage
      self.description = "An interactive component which expands/collapses a panel."
      def demos
        demo Docs::Examples::Collapsible::Default, title: "Default"
      end
    end
  end
end
