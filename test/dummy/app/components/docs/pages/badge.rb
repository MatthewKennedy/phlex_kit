# frozen_string_literal: true

module Docs
  module Pages
    class Badge < Docs::BasePage
      self.description = "Displays a badge or a component that looks like a badge."

      def demos
        demo Docs::Examples::Badge::Variants, title: "Variants"
        demo Docs::Examples::Badge::Status, title: "Status extras"
      end
    end
  end
end
