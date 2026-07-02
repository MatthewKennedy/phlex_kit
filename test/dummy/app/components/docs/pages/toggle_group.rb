# frozen_string_literal: true

module Docs
  module Pages
    class ToggleGroup < Docs::BasePage
      self.description = "A set of two-state buttons that can be toggled on or off."
      def demos
        demo Docs::Examples::ToggleGroup::Default, title: "Single select"
      end
    end
  end
end
